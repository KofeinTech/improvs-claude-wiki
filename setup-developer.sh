#!/usr/bin/env bash
# =============================================================================
# Improvs Developer Machine Setup
# =============================================================================
# Sets up a clean machine with:
#   1. Node.js (if missing)
#   2. Claude Code CLI + org login
#   3. Atlassian account (guided check)
#   4. GitHub MCP server (PAT token)
#   5. Atlassian (Jira) MCP server (API token + Basic Auth)
#   6. Superpowers plugin
#
# No browser is opened. The script prints instructions and asks for tokens.
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
    printf -v "$var_name" '%s' "$token"
}

# Write an MCP server entry into ~/.claude.json using jq.
# Usage: write_mcp_server "server-name" '{"type":"http","url":"...","headers":{...}}'
write_mcp_server() {
    local server_name="$1"
    local server_json="$2"
    local config_file="$HOME/.claude.json"

    # Create file with empty object if missing
    if [[ ! -f "$config_file" ]]; then
        echo '{}' > "$config_file"
    fi

    # Validate the server JSON
    if ! echo "$server_json" | jq empty 2>/dev/null; then
        warn "Invalid JSON for MCP server '$server_name'. Skipping."
        return 1
    fi

    # Merge server into mcpServers (creates key if missing)
    local tmp_file
    tmp_file=$(mktemp)
    jq --arg name "$server_name" --argjson srv "$server_json" \
        '.mcpServers[$name] = $srv' "$config_file" > "$tmp_file" && mv "$tmp_file" "$config_file"

    return 0
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
    step "Step 2/6: Claude Code CLI"

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

        # Verify login succeeded
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
    echo "  To get access to Jira, do the following BEFORE continuing:"
    echo ""
    echo "  1. Create an Atlassian account:"
    echo "     Go to https://id.atlassian.com/signup"
    echo "     Use your work email (e.g. name@improvs.com)"
    echo ""
    echo "  2. Ask your manager to invite you to the Improvs workspace."
    echo "     They go to: https://improvs.atlassian.net/people"
    echo "     and add your email address."
    echo ""
    echo "  3. Accept the invitation email from Atlassian."
    echo ""
    echo "  4. Verify you can open: https://improvs.atlassian.net"
    echo ""

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

    local gh_mcp_json
    gh_mcp_json='{"type":"http","url":"https://api.githubcopilot.com/mcp","headers":{"Authorization":"Bearer YOUR_GITHUB_PAT"}}'

    if write_mcp_server "github" "$gh_mcp_json"; then
        success "GitHub MCP entry added to ~/.claude.json"
    else
        warn "Failed to write GitHub MCP config."
        return
    fi

    echo ""
    echo "  ACTION REQUIRED after setup:"
    echo "  GitHub MCP requires a Personal Access Token to connect."
    echo "  See: ai-playbook/claude-code-setup.md -- section 'Activate GitHub MCP'"
    echo ""
}

# ---------------------------------------------------------------------------
# Step 5: Atlassian (Jira) MCP
# ---------------------------------------------------------------------------
setup_atlassian_mcp() {
    step "Step 5/6: Atlassian (Jira) MCP Server"

    echo "  Jira MCP lets Claude read and update tickets."
    echo "  Uses the official Atlassian MCP server with browser-based OAuth."
    echo ""

    local atlassian_mcp_json
    atlassian_mcp_json='{"type":"http","url":"https://mcp.atlassian.com/v1/mcp"}'

    if write_mcp_server "atlassian" "$atlassian_mcp_json"; then
        success "Atlassian MCP entry added to ~/.claude.json"
    else
        warn "Failed to write Atlassian MCP config."
        return
    fi

    echo ""
    echo "  ACTION REQUIRED after setup:"
    echo "  The first time Claude uses Jira, a browser window will open."
    echo "  Log in with your improvs.atlassian.net account to authorize."
    echo "  See: ai-playbook/claude-code-setup.md -- section 'Activate Atlassian MCP'"
    echo ""
}

# ---------------------------------------------------------------------------
# Step 6: Superpowers Plugin
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

    echo ""
    info "Checking MCP servers in ~/.claude.json..."
    local config_file="$HOME/.claude.json"

    if [[ -f "$config_file" ]] && jq -e '.mcpServers.github' "$config_file" &>/dev/null; then
        success "GitHub MCP: configured"
    else
        warn "GitHub MCP: not found in ~/.claude.json"
        issues=$((issues + 1))
    fi

    if [[ -f "$config_file" ]] && jq -e '.mcpServers.atlassian' "$config_file" &>/dev/null; then
        success "Atlassian MCP: configured"
    else
        warn "Atlassian MCP: not found in ~/.claude.json"
        issues=$((issues + 1))
    fi

    echo ""
    info "Checking plugins..."
    local plugin_output
    plugin_output=$(claude plugin list 2>&1) || true

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
    echo "  2. Verify MCP connections: type /mcp in Claude Code"
    echo "     - github    should show 'connected'"
    echo "     - atlassian should show 'connected'"
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
echo "  You will need the following tokens BEFORE starting:"
echo ""
echo "    1. GitHub Personal Access Token (classic)"
echo "       Create at: https://github.com/settings/tokens/new?scopes=repo,read:org,read:user&description=Claude+Code+MCP"
echo ""
echo "    2. Atlassian API Token"
echo "       Create at: https://id.atlassian.com/manage-profile/security/api-tokens"
echo ""
echo "  The script will guide you through each step."
echo ""

wait_for_user "Press Enter to start..."

detect_os

# jq is required for writing MCP config to ~/.claude.json
if ! command -v jq &>/dev/null; then
    info "Installing jq (required for MCP setup)..."
    case "$OS" in
        macos)          brew install jq 2>/dev/null || { warn "Install jq manually: brew install jq"; } ;;
        linux|wsl)      sudo apt-get install -y jq 2>/dev/null || sudo yum install -y jq 2>/dev/null || { warn "Install jq manually"; } ;;
        *)              warn "Please install jq before continuing: https://jqlang.github.io/jq/download/" ;;
    esac
fi
command -v jq &>/dev/null || fail "jq is required but could not be installed. Install it and re-run."

setup_node
setup_claude
setup_atlassian_account
setup_github_mcp
setup_atlassian_mcp
setup_superpowers
verify_setup
