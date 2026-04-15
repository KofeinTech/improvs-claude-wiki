#!/usr/bin/env bash
# =============================================================================
# Improvs Developer Machine Setup
# =============================================================================
# Sets up a clean machine with:
#   1. Node.js (if missing)
#   2. Claude Code CLI + org login
#   3. GitHub CLI + login (used by Claude Code for all GitHub operations)
#   4. Improvs plugin (skills + Atlassian MCP)
#   5. Superpowers plugin
#
# GitHub access: via gh CLI (no MCP needed -- Claude uses gh commands directly)
# Atlassian MCP: delivered via Improvs plugin, browser OAuth on first use
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

wait_for_user() {
    local msg="${1:-Press Enter when ready to continue...}"
    echo ""
    echo -en "${YELLOW}${msg}${NC}"
    read -r
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
    step "Step 1/5: Node.js"

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
                echo "  Option A -- Install Homebrew first, then re-run:"
                echo "    /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
                echo "    brew install node"
                echo ""
                echo "  Option B -- Download Node.js from: https://nodejs.org/en/download"
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
                echo "  Install Node.js manually from: https://nodejs.org/en/download"
                echo "  After installing, re-run this script."
                exit 1
            fi
            ;;
        windows-git-bash)
            echo "  Download and install Node.js from: https://nodejs.org/en/download"
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
    step "Step 2/5: Claude Code CLI"

    if command -v claude &>/dev/null; then
        success "Claude Code already installed: $(claude --version 2>/dev/null || echo 'installed')"
    else
        info "Installing Claude Code..."
        if npm install -g @anthropic-ai/claude-code 2>/dev/null; then
            true
        elif command -v sudo &>/dev/null; then
            info "Retrying with sudo..."
            sudo npm install -g @anthropic-ai/claude-code
        else
            fail "Cannot install Claude Code globally. Run: sudo npm install -g @anthropic-ai/claude-code"
        fi
        success "Claude Code installed"
    fi

    # Check if already logged in
    local auth_json
    auth_json=$(claude auth status --json 2>/dev/null) || true
    if echo "$auth_json" | grep -q '"loggedIn": true'; then
        local email org
        email=$(echo "$auth_json" | grep '"email"' | sed 's/.*: "//;s/".*//')
        org=$(echo "$auth_json" | grep '"orgName"' | sed 's/.*: "//;s/".*//')
        success "Already logged in as: $email (org: $org)"
        return
    fi

    echo ""
    info "You need to log in to the Improvs Claude organization."
    echo ""
    echo "  This will open a browser for authentication."
    echo "  Log in with the account invited to the Improvs Claude Team org."
    echo ""
    echo "  If you don't have an account yet, ask your manager"
    echo "  for an invitation to the Claude organization."
    echo ""
    echo "  IMPORTANT: After login completes in the browser,"
    echo "  come back to this terminal. If Claude opens interactively,"
    echo "  type /exit or press Ctrl+C to return to the setup."
    echo ""

    local max_attempts=3
    local attempt=0

    while [[ $attempt -lt $max_attempts ]]; do
        attempt=$((attempt + 1))

        wait_for_user "Press Enter to start Claude login..."
        claude login </dev/tty 2>/dev/null || claude login </dev/null || true

        auth_json=$(claude auth status --json 2>/dev/null) || true
        if echo "$auth_json" | grep -q '"loggedIn": true'; then
            local email org
            email=$(echo "$auth_json" | grep '"email"' | sed 's/.*: "//;s/".*//')
            org=$(echo "$auth_json" | grep '"orgName"' | sed 's/.*: "//;s/".*//')
            success "Logged in as: $email (org: $org)"
            return
        fi

        if [[ $attempt -lt $max_attempts ]]; then
            warn "Login not detected. Let's try again. (attempt $attempt/$max_attempts)"
        fi
    done

    warn "Login did not complete after $max_attempts attempts."
    echo "  You can log in later by running: claude login"
}

# ---------------------------------------------------------------------------
# Step 3: GitHub CLI + Login
# ---------------------------------------------------------------------------
setup_github() {
    step "Step 3/5: GitHub CLI"

    echo "  GitHub CLI (gh) gives Claude Code full access to repos, PRs, and issues."
    echo "  No MCP or PAT needed -- Claude uses gh commands directly."
    echo ""

    # Install gh if missing
    if command -v gh &>/dev/null; then
        success "GitHub CLI already installed: $(gh --version 2>/dev/null | head -1)"
    else
        info "GitHub CLI not found. Installing..."
        case "$OS" in
            macos)
                if command -v brew &>/dev/null; then
                    brew install gh
                else
                    echo "  Install GitHub CLI from: https://cli.github.com"
                    echo "  After installing, re-run this script."
                    exit 1
                fi
                ;;
            linux|wsl)
                if command -v apt-get &>/dev/null; then
                    info "Installing via apt..."
                    (type -p wget >/dev/null || (sudo apt-get update -qq && sudo apt-get install -y -qq wget)) \
                        && sudo mkdir -p -m 755 /etc/apt/keyrings \
                        && out=$(mktemp) && wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo tee "$out" > /dev/null \
                        && sudo chmod go+r "$out" && sudo mv "$out" /etc/apt/keyrings/githubcli-archive-keyring.gpg \
                        && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
                        && sudo apt-get update -qq && sudo apt-get install -y -qq gh
                elif command -v dnf &>/dev/null; then
                    sudo dnf install -y gh
                else
                    echo "  Install GitHub CLI from: https://cli.github.com"
                    echo "  After installing, re-run this script."
                    exit 1
                fi
                ;;
            windows-git-bash)
                echo "  Install GitHub CLI from: https://cli.github.com"
                echo "  After installing, restart your terminal and re-run this script."
                exit 1
                ;;
        esac

        if command -v gh &>/dev/null; then
            success "GitHub CLI installed: $(gh --version 2>/dev/null | head -1)"
        else
            warn "GitHub CLI installation failed. Install manually from: https://cli.github.com"
            return
        fi
    fi

    # Check if already authenticated
    if gh auth status &>/dev/null; then
        local gh_user
        gh_user=$(gh api user --jq '.login' 2>/dev/null || echo "authenticated")
        success "GitHub CLI already authenticated as: $gh_user"
        return
    fi

    echo ""
    info "Logging in to GitHub..."
    echo ""
    echo "  A browser will open for GitHub authentication."
    echo "  Log in with your GitHub account that has access to the KofeinTech org."
    echo ""

    gh auth login -h github.com -p https -w </dev/tty 2>/dev/null || gh auth login -h github.com -p https -w || {
        warn "GitHub login did not complete. You can log in later:"
        echo "  gh auth login"
        return
    }

    if gh auth status &>/dev/null; then
        local gh_user
        gh_user=$(gh api user --jq '.login' 2>/dev/null || echo "authenticated")
        success "GitHub authenticated as: $gh_user"
    else
        warn "GitHub login not detected. Run later: gh auth login"
    fi
}

# ---------------------------------------------------------------------------
# Step 4: Improvs Plugin (skills + Atlassian MCP)
# ---------------------------------------------------------------------------
setup_improvs_plugin() {
    step "Step 4/5: Improvs Plugin"

    echo "  The Improvs plugin installs:"
    echo "    - All /slash-command skills (/start, /finish, /review, /test, etc.)"
    echo "    - Atlassian MCP server (browser OAuth on first use)"
    echo ""

    if claude plugin list 2>/dev/null | grep -q "improvs"; then
        success "Improvs plugin already installed"
        echo ""
        echo "  To update or reinstall:"
        echo "  claude plugin install improvs@improvs-marketplace"
        echo ""
        return
    fi

    info "Adding Improvs marketplace..."
    claude plugin marketplace add KofeinTech/claude-plugins 2>/dev/null || true

    info "Installing Improvs plugin..."
    claude plugin install improvs@improvs-marketplace || {
        warn "Plugin install failed. You can install later:"
        echo "  claude plugin marketplace add KofeinTech/claude-plugins"
        echo "  claude plugin install improvs@improvs-marketplace"
        return
    }

    success "Improvs plugin installed (skills + Atlassian MCP)"
    echo ""
    echo "  Atlassian: browser OAuth opens on first Jira interaction."
    echo ""
}

# ---------------------------------------------------------------------------
# Step 5: Superpowers Plugin
# ---------------------------------------------------------------------------
setup_superpowers() {
    step "Step 5/5: Superpowers Plugin"

    echo "  Superpowers gives Claude TDD, structured planning, code review,"
    echo "  and systematic debugging. Improvs /start invokes them automatically."
    echo ""

    if claude plugin list 2>/dev/null | grep -q "superpowers"; then
        success "Superpowers already installed"
        return
    fi

    info "Adding superpowers marketplace..."
    claude plugin marketplace add obra/superpowers-marketplace 2>/dev/null || true

    info "Installing superpowers plugin..."
    claude plugin install superpowers@superpowers-marketplace || {
        warn "Superpowers install failed. You can install later:"
        echo "  claude plugin marketplace add obra/superpowers-marketplace"
        echo "  claude plugin install superpowers@superpowers-marketplace"
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

    if command -v gh &>/dev/null; then
        if gh auth status &>/dev/null; then
            success "GitHub CLI: authenticated"
        else
            warn "GitHub CLI: installed but not authenticated (run: gh auth login)"
            issues=$((issues + 1))
        fi
    else
        warn "GitHub CLI: not found"
        issues=$((issues + 1))
    fi

    echo ""
    info "Checking plugins..."
    local plugin_output
    plugin_output=$(claude plugin list 2>&1) || true

    if echo "$plugin_output" | grep -q "improvs"; then
        success "Improvs plugin: installed (skills + Atlassian MCP)"
    else
        warn "Improvs plugin: not installed"
        issues=$((issues + 1))
    fi

    if echo "$plugin_output" | grep -q "superpowers"; then
        success "Superpowers plugin: installed"
    else
        warn "Superpowers plugin: not installed"
        issues=$((issues + 1))
    fi

    echo ""
    if [[ $issues -eq 0 ]]; then
        success "All tools installed and verified!"
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
    echo "  2. Verify connections:"
    echo "     - GitHub:    gh auth status (should show authenticated)"
    echo "     - Atlassian: type /mcp in Claude Code, browser OAuth on first use"
    echo "     - Figma:     provided separately by your lead (FIGMA_API_KEY env var)"
    echo ""
    echo "  3. Test a skill: type /start <JIRA-KEY>"
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
echo "    - GitHub CLI + authentication"
echo "    - Improvs plugin (skills + Atlassian MCP)"
echo "    - Superpowers plugin"
echo ""
echo "  Everything is handled automatically."
echo ""

wait_for_user "Press Enter to start..."

detect_os
setup_node
setup_claude
setup_github
setup_improvs_plugin
setup_superpowers
verify_setup
