#!/bin/zsh

if [ -z "$ZSH_CONFIG_DIR" ]; then
    echo "Error: ZSH_CONFIG_DIR is not set."
    exit 1
fi

# Colors and symbols
OK="\033[32m✓\033[0m"
WARN="\033[33m!\033[0m"
FAIL="\033[31m✗\033[0m"
SKIP="\033[2m-\033[0m"
BOLD="\033[1m"
RESET="\033[0m"
DIM="\033[2m"

fixed=0
skipped=0
failed=0
already_ok=0

include_optional=false
dry_run=false

# Parse flags
for arg in "$@"; do
    case "$arg" in
        --include-optional) include_optional=true ;;
        --dry-run) dry_run=true ;;
        --help|-h)
            echo "Usage: zc fix [flags]"
            echo ""
            echo "Fixes issues found by 'zc doctor' by installing missing packages"
            echo "and repairing framework configuration."
            echo ""
            echo "Flags:"
            echo "  --include-optional   Also install optional packages"
            echo "  --dry-run            Show what would be done without doing it"
            echo "  --help, -h           Show this help"
            exit 0
            ;;
    esac
done

run_fix() {
    local desc="$1"
    shift
    if $dry_run; then
        echo "  $SKIP  $(printf '%-14s' "$desc") ${DIM}would run: $*${RESET}"
        ((skipped++))
        return 0
    fi
    echo "  ...  $(printf '%-14s' "$desc") ${DIM}$*${RESET}"
    if eval "$@" &>/dev/null; then
        # Move cursor up and overwrite
        echo "\033[1A  $OK  $(printf '%-14s' "$desc") ${DIM}installed${RESET}"
        ((fixed++))
        return 0
    else
        echo "\033[1A  $FAIL  $(printf '%-14s' "$desc") ${DIM}install failed${RESET}"
        ((failed++))
        return 1
    fi
}

mark_ok() {
    local desc="$1"
    echo "  $OK  $(printf '%-14s' "$desc") ${DIM}already installed${RESET}"
    ((already_ok++))
}

mark_skip() {
    local desc="$1"
    local reason="$2"
    echo "  $SKIP  $(printf '%-14s' "$desc") ${DIM}$reason${RESET}"
    ((skipped++))
}

require_brew() {
    if ! command -v brew &>/dev/null; then
        echo "${FAIL}  Homebrew is required but not installed."
        echo "  ${DIM}Install: /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\"${RESET}"
        exit 1
    fi
}

fix_cmd_brew() {
    local name="$1"
    local pkg="$2"
    local optional="$3"
    if command -v "$name" &>/dev/null; then
        mark_ok "$name"
    elif [ "$optional" = "optional" ] && ! $include_optional; then
        mark_skip "$name" "optional — use --include-optional"
    else
        require_brew
        run_fix "$name" "brew install $pkg"
    fi
}

fix_cmd_brew_cask() {
    local name="$1"
    local pkg="$2"
    local optional="$3"
    if command -v "$name" &>/dev/null; then
        mark_ok "$name"
    elif [ "$optional" = "optional" ] && ! $include_optional; then
        mark_skip "$name" "optional — use --include-optional"
    else
        require_brew
        run_fix "$name" "brew install --cask $pkg"
    fi
}

fix_cmd_pipx() {
    local name="$1"
    local pkg="$2"
    local optional="$3"
    if command -v "$name" &>/dev/null; then
        mark_ok "$name"
    elif [ "$optional" = "optional" ] && ! $include_optional; then
        mark_skip "$name" "optional — use --include-optional"
    else
        if ! command -v pipx &>/dev/null; then
            require_brew
            run_fix "pipx" "brew install pipx"
        fi
        run_fix "$name" "pipx install $pkg"
    fi
}

fix_cmd_npm() {
    local name="$1"
    local pkg="$2"
    local optional="$3"
    if command -v "$name" &>/dev/null; then
        mark_ok "$name"
    elif [ "$optional" = "optional" ] && ! $include_optional; then
        mark_skip "$name" "optional — use --include-optional"
    else
        if ! command -v npm &>/dev/null; then
            echo "  $FAIL  $(printf '%-14s' "$name") ${DIM}npm required but not available — install nvm first${RESET}"
            ((failed++))
            return 1
        fi
        run_fix "$name" "npm install -g $pkg"
    fi
}

echo "${BOLD}zc fix${RESET}"
$dry_run && echo "${DIM}(dry run — no changes will be made)${RESET}"
$include_optional && echo "${DIM}(including optional packages)${RESET}"
echo ""

# --- Framework ---
echo "${BOLD}Framework${RESET}"

for dir in "$ZSH_CONFIG_DIR/default_configs" "$ZSH_CONFIG_DIR/scripts" "$ZSH_CONFIG_DIR/workconfigs"; do
    name=$(basename "$dir")
    if [ -d "$dir" ]; then
        mark_ok "$name"
    else
        run_fix "$name" "mkdir -p '$dir'"
    fi
done

for file in "zshrc.sh" "ohmyzsh.sh"; do
    if [ -f "$ZSH_CONFIG_DIR/$file" ]; then
        mark_ok "$file"
    else
        echo "  $FAIL  $(printf '%-14s' "$file") ${DIM}missing — cannot auto-create, run zc setup${RESET}"
        ((failed++))
    fi
done

# zc in PATH
if command -v zc &>/dev/null; then
    mark_ok "zc in PATH"
else
    echo "  $WARN  $(printf '%-14s' "zc in PATH") ${DIM}add to your shell: export PATH=\$ZSH_CONFIG_DIR:\$PATH${RESET}"
    ((skipped++))
fi
echo ""

# --- Oh My Zsh ---
echo "${BOLD}Oh My Zsh${RESET}"
if [ -d "$HOME/.oh-my-zsh" ]; then
    mark_ok "oh-my-zsh"
else
    run_fix "oh-my-zsh" 'sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended'
fi

# Theme sync
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
if [ -f "$ZSH_CUSTOM/themes/custom.zsh-theme" ]; then
    mark_ok "theme synced"
elif [ -f "$ZSH_CONFIG_DIR/custom.zsh-theme" ] && [ -d "$ZSH_CUSTOM/themes" ]; then
    run_fix "theme synced" "cp '$ZSH_CONFIG_DIR/custom.zsh-theme' '$ZSH_CUSTOM/themes/custom.zsh-theme'"
else
    mark_skip "theme synced" "oh-my-zsh custom dir not ready"
fi

# zsh-vi-mode plugin
if [ -d "$ZSH_CUSTOM/plugins/zsh-vi-mode" ]; then
    mark_ok "zsh-vi-mode"
else
    run_fix "zsh-vi-mode" "git clone https://github.com/jeffreytse/zsh-vi-mode '$ZSH_CUSTOM/plugins/zsh-vi-mode'"
fi
echo ""

# --- Core tools ---
echo "${BOLD}Core tools${RESET}"
fix_cmd_brew "git" "git"
fix_cmd_brew "nvim" "neovim"
fix_cmd_brew "curl" "curl"
fix_cmd_brew "uv" "uv"
fix_cmd_brew "diff-so-fancy" "diff-so-fancy"
echo ""

# --- Python ---
echo "${BOLD}Python${RESET}"

# Install python3 via uv
if command -v python3 &>/dev/null; then
    mark_ok "python3"
else
    if command -v uv &>/dev/null; then
        run_fix "python3" "uv python install"
    else
        echo "  $FAIL  $(printf '%-14s' "python3") ${DIM}uv required — install uv first${RESET}"
        ((failed++))
    fi
fi

# uvx comes with uv
if command -v uvx &>/dev/null; then
    mark_ok "uvx"
else
    mark_skip "uvx" "comes with uv"
fi
fix_cmd_brew "pipx" "pipx" "optional"
echo ""

# --- Node ---
echo "${BOLD}Node${RESET}"

# nvm (special: not a binary, it's a shell function)
nvm_dir="${NVM_DIR:-$HOME/.nvm}"
if [ -d "$nvm_dir" ]; then
    mark_ok "nvm"
elif $include_optional; then
    run_fix "nvm" 'PROFILE=/dev/null bash -c "$(curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/HEAD/install.sh)"'
else
    mark_skip "nvm" "optional — use --include-optional"
fi

# node/npm require nvm
fix_cmd_brew "node" "node" "optional"
fix_cmd_brew "npm" "npm" "optional"
fix_cmd_npm "yarn" "yarn" "optional"
echo ""

# --- Kubernetes & Cloud ---
echo "${BOLD}Kubernetes & Cloud${RESET}"
fix_cmd_brew "kubectl" "kubectl" "optional"
fix_cmd_brew "kubectx" "kubectx" "optional"
fix_cmd_brew "helm" "helm" "optional"
fix_cmd_brew_cask "docker" "docker" "optional"
fix_cmd_brew "aws" "awscli" "optional"
echo ""

# --- Other tools ---
echo "${BOLD}Other tools${RESET}"
fix_cmd_brew "fzf" "fzf" "optional"
fix_cmd_brew "fd" "fd" "optional"
fix_cmd_brew "go" "go" "optional"
fix_cmd_brew "redis-cli" "redis" "optional"

# Autojump (special: check known paths)
if command -v autojump &>/dev/null || [ -f /opt/homebrew/etc/profile.d/autojump.sh ] || [ -f /usr/share/autojump/autojump.sh ]; then
    mark_ok "autojump"
elif $include_optional; then
    require_brew
    run_fix "autojump" "brew install autojump"
else
    mark_skip "autojump" "optional — use --include-optional"
fi
echo ""

# --- Work configs ---
echo "${BOLD}Work configs${RESET}"
if [ -f "$ZSH_CONFIG_DIR/.active_work_configs" ] && [ -s "$ZSH_CONFIG_DIR/.active_work_configs" ]; then
    while read -r wc; do
        if [ -d "$ZSH_CONFIG_DIR/workconfigs/$wc" ]; then
            mark_ok "$wc"
        else
            echo "  $FAIL  $(printf '%-14s' "$wc") ${DIM}active but directory missing — run: zc workconfig deactivate $wc${RESET}"
            ((failed++))
        fi
    done < "$ZSH_CONFIG_DIR/.active_work_configs"
else
    echo "  ${DIM}(no active work configs)${RESET}"
fi
echo ""

# --- Summary ---
total=$((fixed + skipped + failed + already_ok))
echo "${BOLD}Summary${RESET}"
[ $already_ok -gt 0 ] && echo "  $OK  $already_ok already OK"
[ $fixed -gt 0 ] && echo "  $OK  $fixed fixed"
[ $skipped -gt 0 ] && echo "  $WARN  $skipped skipped"
[ $failed -gt 0 ] && echo "  $FAIL  $failed failed"
[ $failed -eq 0 ] && [ $skipped -eq 0 ] && echo "  $OK  Everything looks good!"

exit $(( failed > 0 ? 1 : 0 ))
