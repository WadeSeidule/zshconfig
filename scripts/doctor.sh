#!/bin/zsh

if [ -z "$ZSH_CONFIG_DIR" ]; then
    echo "Error: ZSH_CONFIG_DIR is not set."
    exit 1
fi

# Colors and symbols
OK="\033[32m✓\033[0m"
WARN="\033[33m!\033[0m"
FAIL="\033[31m✗\033[0m"
BOLD="\033[1m"
RESET="\033[0m"
DIM="\033[2m"

pass=0
warn=0
fail=0

check_cmd() {
    local name="$1"
    local hint="$2"
    local label
    label=$(printf '%-14s' "$name")
    if command -v "$name" &>/dev/null; then
        local ver
        ver=$("$name" --version 2>&1 | head -1 | grep -oE '[0-9]+\.[0-9]+[.0-9]*' | head -1)
        echo "  $OK  $label ${DIM}${ver:-installed}${RESET}"
        ((pass++))
    else
        echo "  $FAIL  $label ${DIM}not found${hint:+ — $hint}${RESET}"
        ((fail++))
    fi
}

check_cmd_optional() {
    local name="$1"
    local hint="$2"
    local label
    label=$(printf '%-14s' "$name")
    if command -v "$name" &>/dev/null; then
        local ver
        ver=$("$name" --version 2>&1 | head -1 | grep -oE '[0-9]+\.[0-9]+[.0-9]*' | head -1)
        echo "  $OK  $label ${DIM}${ver:-installed}${RESET}"
        ((pass++))
    else
        echo "  $WARN  $label ${DIM}not found (optional)${hint:+ — $hint}${RESET}"
        ((warn++))
    fi
}

check_dir() {
    local path="$1"
    local name="$2"
    local label
    label=$(printf '%-14s' "$name")
    if [ -d "$path" ]; then
        echo "  $OK  $label ${DIM}$path${RESET}"
        ((pass++))
    else
        echo "  $FAIL  $label ${DIM}$path not found${RESET}"
        ((fail++))
    fi
}

check_file() {
    local path="$1"
    local name="$2"
    local label
    label=$(printf '%-14s' "$name")
    if [ -f "$path" ]; then
        echo "  $OK  $label ${DIM}$path${RESET}"
        ((pass++))
    else
        echo "  $FAIL  $label ${DIM}$path not found${RESET}"
        ((fail++))
    fi
}

echo "${BOLD}zc doctor${RESET}"
echo ""

# --- Framework ---
echo "${BOLD}Framework${RESET}"
check_dir "$ZSH_CONFIG_DIR" "config dir"
check_dir "$ZSH_CONFIG_DIR/default_configs" "defaults"
check_dir "$ZSH_CONFIG_DIR/scripts" "scripts"
check_dir "$ZSH_CONFIG_DIR/workconfigs" "workconfigs"
check_file "$ZSH_CONFIG_DIR/zshrc.sh" "zshrc.sh"
check_file "$ZSH_CONFIG_DIR/ohmyzsh.sh" "ohmyzsh.sh"
check_file "$ZSH_CONFIG_DIR/custom.zsh-theme" "theme"

# Check zc is in PATH
label=$(printf '%-14s' "zc in PATH")
if command -v zc &>/dev/null; then
    echo "  $OK  $label"
    ((pass++))
else
    echo "  $FAIL  $label ${DIM}run: export PATH=\$ZSH_CONFIG_DIR:\$PATH${RESET}"
    ((fail++))
fi
echo ""

# --- Oh My Zsh ---
echo "${BOLD}Oh My Zsh${RESET}"
check_dir "$HOME/.oh-my-zsh" "oh-my-zsh"

# Custom theme installed
label=$(printf '%-14s' "theme synced")
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
if [ -f "$ZSH_CUSTOM/themes/custom.zsh-theme" ]; then
    echo "  $OK  $label"
    ((pass++))
else
    echo "  $WARN  $label ${DIM}run: zc update-theme${RESET}"
    ((warn++))
fi

# Custom plugins
label=$(printf '%-14s' "zsh-vi-mode")
if [ -d "$ZSH_CUSTOM/plugins/zsh-vi-mode" ]; then
    echo "  $OK  $label"
    ((pass++))
else
    echo "  $WARN  $label ${DIM}will auto-install on next shell start${RESET}"
    ((warn++))
fi
echo ""

# --- Core tools ---
echo "${BOLD}Core tools${RESET}"
check_cmd "git" ""
check_cmd "nvim" "brew install neovim"
check_cmd "curl" ""
echo ""

# --- Python ---
echo "${BOLD}Python${RESET}"
check_cmd "python3" ""
check_cmd_optional "uv" "brew install uv"
check_cmd_optional "uvx" "comes with uv"
check_cmd_optional "pyenv" "brew install pyenv"
check_cmd_optional "poetry" "pipx install poetry"
check_cmd_optional "pipx" "brew install pipx"
echo ""

# --- Node ---
echo "${BOLD}Node${RESET}"
check_cmd_optional "node" "install via nvm"
check_cmd_optional "npm" "install via nvm"
check_cmd_optional "yarn" "npm install -g yarn"

# Check nvm (it's a function, not a binary)
label=$(printf '%-14s' "nvm")
if [ -d "$HOME/.nvm" ]; then
    echo "  $OK  $label ${DIM}$HOME/.nvm${RESET}"
    ((pass++))
elif [ -n "$NVM_DIR" ] && [ -d "$NVM_DIR" ]; then
    echo "  $OK  $label ${DIM}$NVM_DIR${RESET}"
    ((pass++))
else
    echo "  $WARN  $label ${DIM}not found (optional)${RESET}"
    ((warn++))
fi
echo ""

# --- Kubernetes & Cloud ---
echo "${BOLD}Kubernetes & Cloud${RESET}"
check_cmd_optional "kubectl" "brew install kubectl"
check_cmd_optional "kubectx" "brew install kubectx"
check_cmd_optional "helm" "brew install helm"
check_cmd_optional "docker" "brew install --cask docker"
check_cmd_optional "aws" "brew install awscli"
echo ""

# --- Other tools ---
echo "${BOLD}Other tools${RESET}"
check_cmd_optional "fzf" "brew install fzf"
check_cmd_optional "fd" "brew install fd"
check_cmd_optional "go" "brew install go"
check_cmd_optional "redis-cli" "brew install redis"

# Autojump (check known paths)
label=$(printf '%-14s' "autojump")
if command -v autojump &>/dev/null; then
    echo "  $OK  $label"
    ((pass++))
elif [ -f /opt/homebrew/etc/profile.d/autojump.sh ]; then
    echo "  $OK  $label ${DIM}via homebrew${RESET}"
    ((pass++))
elif [ -f /usr/share/autojump/autojump.sh ]; then
    echo "  $OK  $label ${DIM}via apt${RESET}"
    ((pass++))
else
    echo "  $WARN  $label ${DIM}not found (optional) — brew install autojump${RESET}"
    ((warn++))
fi
echo ""

# --- Active workconfigs ---
echo "${BOLD}Work configs${RESET}"
if [ -f "$ZSH_CONFIG_DIR/.active_work_configs" ] && [ -s "$ZSH_CONFIG_DIR/.active_work_configs" ]; then
    while read -r wc; do
        label=$(printf '%-14s' "$wc")
        if [ -d "$ZSH_CONFIG_DIR/workconfigs/$wc" ]; then
            echo "  $OK  $label ${DIM}active${RESET}"
            ((pass++))
        else
            echo "  $FAIL  $label ${DIM}active but directory missing — zc workconfig deactivate $wc${RESET}"
            ((fail++))
        fi
    done < "$ZSH_CONFIG_DIR/.active_work_configs"
else
    echo "  ${DIM}(no active work configs)${RESET}"
fi

# List inactive
for dir in "$ZSH_CONFIG_DIR/workconfigs"/*/; do
    [ -d "$dir" ] || continue
    wc=$(basename "$dir")
    if [ ! -f "$ZSH_CONFIG_DIR/.active_work_configs" ] || ! grep -qxF "$wc" "$ZSH_CONFIG_DIR/.active_work_configs"; then
        label=$(printf '%-14s' "$wc")
        echo "  ${DIM}-  $label inactive${RESET}"
    fi
done
echo ""

# --- Summary ---
total=$((pass + warn + fail))
echo "${BOLD}Summary${RESET}: $pass/$total passed"
[ $warn -gt 0 ] && echo "  ${WARN}  $warn warnings"
[ $fail -gt 0 ] && echo "  ${FAIL}  $fail issues"
[ $fail -eq 0 ] && [ $warn -eq 0 ] && echo "  ${OK}  All checks passed!"

exit $(( fail > 0 ? 1 : 0 ))
