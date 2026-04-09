#!/usr/bin/env bash
# =============================================================================
# Improvs Developer Machine Setup
# =============================================================================
# Sets up a clean machine with:
#   1. Node.js (if missing)
#   2. Claude Code CLI + org login
#   3. Atlassian account (guided signup if needed)
#   4. GitHub MCP server (with PAT)
#   5. Atlassian (Jira) MCP server (OAuth)
#   6. Superpowers plugin
#
# Usage:
#   ./setup-developer.sh
#
# Supports: macOS, Linux, Windows (WSL/Git Bash)
# =============================================================================

set -euo pipefail

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m'

info()    { echo -e "${BLUE}[INFO]${NC} $1"; }
success() { echo -e "${GREEN}[OK]${NC} $1"; }
warn()    { echo -e "${YELLOW}[WARN]${NC} $1"; }
fail()    { echo -e "${RED}[FAIL]${NC} $1"; exit 1; }
step()    { echo -e "\n${BOLD}============================================${NC}"; info "$1"; echo -e "${BOLD}============================================${NC}\n"; }

open_url() {
    local url="$1"
    if command -v open &>/dev/null; then
        open "$url"
    elif command -v xdg-open &>/dev/null; then
        xdg-open "$url"
    elif command -v wslview &>/dev/null; then
        wslview "$url"
    elif command -v explorer.exe &>/dev/null; then
        explorer.exe "$url"
    else
        warn "Cannot open browser automatically."
        echo "  Open this URL manually: $url"
    fi
}

wait_for_user() {
    local msg="${1:-Press Enter when ready to continue...}"
    echo ""
    echo -en "${YELLOW}${msg}${NC}"
    read -r
}

prompt_yn() {
    local msg="$1"
    local answer=""
    echo -en "${YELLOW}${msg} (y/n): ${NC}"
    read -r answer
    [[ "$answer" =~ ^[Yy] ]]
}

prompt_token() {
    local var_name="$1"
    local prompt_text="$2"
    local token=""
    while [[ -z "$token" ]]; do
        echo -en "${YELLOW}$prompt_text${NC}"
        read -r token
        if [[ -z "$token" ]]; then
            warn "Cannot be empty. Try again."
        fi
    done
    eval "$var_name='$token'"
}

# ---------------------------------------------------------------------------
# Detect OS
# ---------------------------------------------------------------------------
detect_os() {
    case "$(uname -s)" in
        Darwin*)  OS="macos" ;;
        Linux*)
            if grep -qEi "(Microsoft|WSL)" /proc/version 2>/dev/null; then
                OS="wsl"
            else
                OS="linux"
            fi
            ;;
        MINGW*|MSYS*|CYGWIN*) OS="windows-git-bash" ;;
        *)        fail "Unsupported OS: $(uname -s)" ;;
    esac
    success "Detected OS: $OS"
}

# ---------------------------------------------------------------------------
# Step 1: Node.js
# ---------------------------------------------------------------------------
setup_node() {
    step "Step 1/6: Node.js"

    if command -v node &>/dev/null; then
        success "Node.js already installed: $(node -v)"
        return
    fi

    info "Node.js not found. Installing..."
    case "$OS" in
        macos)
            if command -v brew &>/dev/null; then
                brew install node
            else
                echo "  Node.js is required but Homebrew is not installed."
                echo ""
                echo "  Option A: Install Homebrew first, then re-run:"
                echo "    /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
                echo "    brew install node"
                echo ""
                echo "  Option B: Download Node.js directly:"
                open_url "https://nodejs.org/en/download"
                echo ""
                echo "  After installing Node.js, re-run this script."
                exit 1
            fi
            ;;
        linux|wsl)
            if command -v apt-get &>/dev/null; then
                info "Installing via apt..."
                sudo apt-get update -qq
                sudo apt-get install -y -qq nodejs npm
            elif command -v dnf &>/dev/null; then
                sudo dnf install -y nodejs npm
            else
                echo "  Install Node.js manually:"
                echo "    https://nodejs.org/en/download"
                echo ""
                echo "  After installing, re-run this script."
                exit 1
            fi
            ;;
        windows-git-bash)
            echo "  Download and install Node.js:"
            echo "    https://nodejs.org/en/download"
            open_url "https://nodejs.org/en/download"
            echo ""
            echo "  After installing, restart your terminal and re-run this script."
            exit 1
            ;;
    esac
    success "Node.js installed: $(node -v)"
}

# ---------------------------------------------------------------------------
# Step 2: Claude Code CLI + Login
# ---------------------------------------------------------------------------
setup_claude() {
    step "Step 2/6: Claude Code CLI"

    if command -v claude &>/dev/null; then
        success "Claude Code already installed: $(claude --version 2>/dev/null || echo 'installed')"
    else
        info "Installing Claude Code..."
        npm install -g @anthropic-ai/claude-code
        success "Claude Code installed"
    fi

    echo ""
    info "Now you need to log in to your Improvs Claude organization account."
    echo ""
    echo "  This will open a browser window. Log in with the account"
    echo "  that was invited to the Improvs Claude Team organization."
    echo ""
    echo "  If you don't have an account yet, ask your manager"
    echo "  for an invitation to the Claude organization."
    echo ""

    wait_for_user "Press Enter to start Claude login..."

    claude login || {
        warn "Login did not complete. You can log in later by running: claude login"
    }
}

# ---------------------------------------------------------------------------
# Step 3: Atlassian account check
# ---------------------------------------------------------------------------
setup_atlassian_account() {
    step "Step 3/6: Atlassian (Jira) Account"

    echo "  You need an Atlassian account with access to improvs.atlassian.net"
    echo ""

    if prompt_yn "Do you already have access to improvs.atlassian.net?"; then
        success "Atlassian account confirmed"
        return
    fi

    echo ""
    echo "  To get access to Jira:"
    echo ""
    echo "  1. Go to: https://id.atlassian.com/signup"
    echo "     Create an account with your work email"
    echo ""
    echo "  2. Ask your manager to invite you to improvs.atlassian.net"
    echo "     They need to go to:"
    echo "     https://improvs.atlassian.net/people"
    echo "     and add your email address"
    echo ""
    echo "  3. Accept the invitation email from Atlassian"
    echo ""
    echo "  4. Verify you can open: https://improvs.atlassian.net"
    echo ""

    open_url "https://id.atlassian.com/signup"

    wait_for_user "Press Enter once you have access to improvs.atlassian.net..."
    success "Atlassian account setup done"
}

# ---------------------------------------------------------------------------
# Step 4: GitHub MCP
# ---------------------------------------------------------------------------
setup_github_mcp() {
    step "Step 4/6: GitHub MCP Server"

    echo "  GitHub MCP lets Claude read repos, create PRs, and manage issues."
    echo ""
    echo "  You need a Personal Access Token (classic). The script will"
    echo "  open GitHub with the right scopes pre-selected."
    echo ""
    echo "  Required scopes (pre-filled):"
    echo "    - repo        (access private repos)"
    echo "    - read:org    (read org membership)"
    echo "    - read:user   (read profile data)"
    echo ""

    if ! prompt_yn "Do you have a GitHub account?"; then
        echo ""
        echo "  Create a GitHub account first:"
        echo "    https://github.com/signup"
        echo ""
        echo "  Then ask your manager to add you to the 'kofeintech' org."
        echo ""
        open_url "https://github.com/signup"
        wait_for_user "Press Enter once you have a GitHub account and org access..."
    fi

    echo ""
    info "Opening GitHub token creation page..."
    echo ""
    echo "  1. Set a name (e.g. 'Claude Code MCP')"
    echo "  2. Set expiration (recommended: 90 days)"
    echo "  3. Scopes are pre-selected -- don't change them"
    echo "  4. Click 'Generate token'"
    echo "  5. Copy the token (starts with ghp_...)"
    echo ""

    open_url "https://github.com/settings/tokens/new?scopes=repo,read:org,read:user&description=Claude+Code+MCP"

    wait_for_user "Press Enter once you see the token..."

    prompt_token GITHUB_PAT "Paste your GitHub token here: "

    info "Adding GitHub MCP to Claude Code..."
    claude mcp add-json github "{\"type\":\"http\",\"url\":\"https://api.githubcopilot.com/mcp\",\"headers\":{\"Authorization\":\"Bearer $GITHUB_PAT\"}}" --scope user

    success "GitHub MCP configured"
}

# ---------------------------------------------------------------------------
# Step 5: Atlassian (Jira) MCP
# ---------------------------------------------------------------------------
setup_atlassian_mcp() {
    step "Step 5/6: Atlassian (Jira) MCP Server"

    echo "  Jira MCP lets Claude read tickets and update status."
    echo "  Uses the official Atlassian Rovo MCP server with OAuth."
    echo ""
    echo "  When you first use it in Claude Code, a browser window will"
    echo "  open asking you to authorize Atlassian. Log in with the"
    echo "  account that has access to improvs.atlassian.net."
    echo ""

    info "Adding Atlassian MCP to Claude Code..."
    claude mcp add --transport http --scope user atlassian https://mcp.atlassian.com/v1/mcp

    success "Atlassian MCP configured"
    echo ""
    echo "  Authentication happens automatically when Claude"
    echo "  first tries to use Jira. A browser window will open."
}

# ---------------------------------------------------------------------------
# Step 6: (reserved -- Figma API key provided manually by lead)
# ---------------------------------------------------------------------------

# ---------------------------------------------------------------------------
# Step 7: Superpowers Plugin
# ---------------------------------------------------------------------------
setup_superpowers() {
    step "Step 6/6: Superpowers Plugin"

    echo "  Superpowers gives Claude TDD, structured planning, code review,"
    echo "  and systematic debugging skills. Improvs /start invokes them"
    echo "  automatically based on task complexity."
    echo ""

    if claude plugin list 2>/dev/null | grep -q "superpowers"; then
        success "Superpowers already installed"
        return
    fi

    info "Installing superpowers plugin..."
    claude plugin install superpowers@claude-plugins-official || {
        warn "Superpowers install failed. You can install later:"
        echo "  claude plugin install superpowers@claude-plugins-official"
        return
    }

    success "Superpowers installed"
}

# ---------------------------------------------------------------------------
# Verify & Summary
# ---------------------------------------------------------------------------
verify_setup() {
    step "Setup Complete -- Verification"

    local issues=0

    if command -v node &>/dev/null; then
        success "Node.js: $(node -v)"
    else
        warn "Node.js: not found"
        issues=$((issues + 1))
    fi

    if command -v claude &>/dev/null; then
        success "Claude Code: $(claude --version 2>/dev/null || echo 'installed')"
    else
        warn "Claude Code: not found"
        issues=$((issues + 1))
    fi

    echo ""
    info "Configured MCP servers:"
    claude mcp list 2>/dev/null || warn "Could not list MCP servers"

    echo ""
    if [[ $issues -eq 0 ]]; then
        success "All tools installed successfully!"
    else
        warn "$issues issue(s) detected. See warnings above."
    fi

    echo ""
    echo -e "${BOLD}============================================${NC}"
    echo -e "${BOLD}  What to do next${NC}"
    echo -e "${BOLD}============================================${NC}"
    echo ""
    echo "  1. Open any project and run: claude"
    echo ""
    echo "  2. Verify MCP connections: type /mcp in Claude Code"
    echo "     - github    should show 'connected'"
    echo "     - atlassian should prompt OAuth on first use"
    echo "     - figma     provided separately by your lead (FIGMA_API_KEY env var)"
    echo ""
    echo "  3. Test a skill: type /start <JIRA-KEY>"
    echo "     Skills are delivered via your Claude org automatically."
    echo ""
    echo "  Useful links:"
    echo "    Jira:   https://improvs.atlassian.net"
    echo "    GitHub: https://github.com/kofeintech"
    echo ""
    echo "  If something doesn't work, ask in the team Telegram chat"
    echo "  or re-run this script."
    echo ""
}

# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------
echo ""
echo -e "${BOLD}============================================${NC}"
echo -e "${BOLD}  Improvs Developer Setup${NC}"
echo -e "${BOLD}============================================${NC}"
echo ""
echo "  This script will set up your machine for development:"
echo "    - Node.js"
echo "    - Claude Code CLI + organization login"
echo "    - Atlassian (Jira) account + MCP"
echo "    - GitHub MCP"
echo "    - Superpowers plugin"
echo ""
echo "  It will open browser windows for login/signup."
echo "  Follow the instructions for each step."
echo ""

wait_for_user "Press Enter to start..."

detect_os
setup_node
setup_claude
setup_atlassian_account
setup_github_mcp
setup_atlassian_mcp
setup_superpowers
verify_setup
