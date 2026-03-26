#!/bin/zsh

if [ -z "$ZSH_CONFIG_DIR" ]; then
    echo "Error: ZSH_CONFIG_DIR is not set."
    exit 1
fi

BOLD="\033[1m"
DIM="\033[2m"
RESET="\033[0m"
YELLOW="\033[33m"
RED="\033[31m"
GREEN="\033[32m"

echo "${BOLD}zc profile${RESET}"
echo ""

# --- Total startup time ---
echo "${BOLD}Total startup time${RESET} (best of 3):"
best=""
for i in 1 2 3; do
    # Use a subshell with EPOCHREALTIME for precise measurement
    ms=$(zsh -c '
        zmodload zsh/datetime
        s=$EPOCHREALTIME
        source "'$HOME'/.zshrc" 2>/dev/null
        e=$EPOCHREALTIME
        printf "%.0f" $(( (e - s) * 1000 ))
    ' 2>/dev/null)
    if [ -n "$ms" ]; then
        echo "  Run $i: ${ms}ms"
        if [ -z "$best" ] || [ "$ms" -lt "$best" ]; then
            best=$ms
        fi
    else
        echo "  Run $i: (failed to measure)"
    fi
done
if [ -n "$best" ]; then
    color=$GREEN
    [ "$best" -gt 500 ] && color=$YELLOW
    [ "$best" -gt 1000 ] && color=$RED
    echo "  ${BOLD}Best: ${color}${best}ms${RESET}"
fi
echo ""

# --- Per-file breakdown ---
echo "${BOLD}Per-file breakdown${RESET} (sorted slowest first):"
echo ""

# Create an instrumented loader in a temp dir and use ZDOTDIR to run it
# as a real interactive shell
tmpdir=$(mktemp -d)
cat > "$tmpdir/.zshrc" <<'PROFILERC'
zmodload zsh/datetime
typeset -a _pf_results

_pf_source() {
    local label="$1"
    local file="$2"
    [ -f "$file" ] || return
    local s=$EPOCHREALTIME
    source "$file" 2>/dev/null
    local e=$EPOCHREALTIME
    local ms=$(( (e - s) * 1000 ))
    _pf_results+=("$(printf '%9.1fms  %s' $ms "$label")")
}

_pf_total_s=$EPOCHREALTIME

# Default configs
for file in "$ZSH_CONFIG_DIR/default_configs"/*.sh; do
    _pf_source "default_configs/$(basename "$file")" "$file"
done

# Active work configs
if [ -f "$ZSH_CONFIG_DIR/.active_work_configs" ]; then
    while read -r wc; do
        for file in "$ZSH_CONFIG_DIR/workconfigs/$wc"/zsh*.sh; do
            [ -f "$file" ] || continue
            _pf_source "workconfigs/$wc/$(basename "$file")" "$file"
        done
    done < "$ZSH_CONFIG_DIR/.active_work_configs"
fi

# Oh-my-zsh (usually the heavy one)
_pf_source "ohmyzsh.sh" "$ZSH_CONFIG_DIR/ohmyzsh.sh"

_pf_total_e=$EPOCHREALTIME
_pf_total_ms=$(( (_pf_total_e - _pf_total_s) * 1000 ))

# Print sorted results
printf '%s\n' "${_pf_results[@]}" | sort -rn

# Summary bar
printf '\n  %9.0fms  TOTAL (sourcing only)\n' $_pf_total_ms

# Tip if slow
if (( _pf_total_ms > 800 )); then
    printf '\n  Tip: ohmyzsh.sh is usually the biggest cost.\n'
    printf '  Consider enabling lazy loading for nvm/pyenv in zshexports.sh.\n'
fi
PROFILERC

# Run the instrumented shell. ZDOTDIR override makes it use our .zshrc
# instead of the real one, giving us a clean profile.
ZDOTDIR="$tmpdir" ZSH_CONFIG_DIR="$ZSH_CONFIG_DIR" HOME="$HOME" zsh -i -c "" 2>/dev/null

rm -rf "$tmpdir"
