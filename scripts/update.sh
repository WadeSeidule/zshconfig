#!/bin/zsh

if [ -z "$ZSH_CONFIG_DIR" ]; then
    echo "Error: ZSH_CONFIG_DIR is not set."
    exit 1
fi

OK="\033[32m✓\033[0m"
WARN="\033[33m!\033[0m"
FAIL="\033[31m✗\033[0m"
SKIP="\033[2m-\033[0m"
BOLD="\033[1m"
RESET="\033[0m"
DIM="\033[2m"

dry_run=false
for arg in "$@"; do
    case "$arg" in
        --dry-run) dry_run=true ;;
        --help|-h)
            echo "Usage: zc update [--dry-run]"
            echo ""
            echo "Pulls latest changes from the zshconfig repo and applies post-pull"
            echo "updates (re-syncs the custom oh-my-zsh theme if it changed)."
            echo ""
            echo "Refuses to run if the working tree has uncommitted changes or if"
            echo "the local branch is ahead of upstream."
            echo ""
            echo "Flags:"
            echo "  --dry-run    Show what would be done without doing it"
            echo "  --help, -h   Show this help"
            exit 0
            ;;
        *)
            echo "Unknown arg: $arg (see --help)"
            exit 1
            ;;
    esac
done

cd "$ZSH_CONFIG_DIR" || { echo "Error: cannot cd to $ZSH_CONFIG_DIR"; exit 1; }

if [ ! -d ".git" ]; then
    echo "  $FAIL  $ZSH_CONFIG_DIR is not a git repo — nothing to update."
    exit 1
fi

echo "${BOLD}zc update${RESET}"
$dry_run && echo "${DIM}(dry run — no changes will be made)${RESET}"
echo ""

# Pre-flight: working tree must be clean
if ! git diff --quiet || ! git diff --cached --quiet; then
    echo "  $FAIL  working tree has uncommitted changes — refusing to pull"
    echo "${DIM}  commit or stash, then re-run${RESET}"
    echo ""
    git status --short | sed 's/^/  /'
    exit 1
fi

branch=$(git rev-parse --abbrev-ref HEAD)
before=$(git rev-parse HEAD)

# Fetch
echo "  ${DIM}fetching origin/$branch...${RESET}"
if $dry_run; then
    git fetch --dry-run 2>&1 | sed 's/^/  /'
else
    if ! git fetch --quiet; then
        echo "  $FAIL  fetch failed"
        exit 1
    fi
fi

# Upstream check
if ! upstream=$(git rev-parse '@{u}' 2>/dev/null); then
    echo "  $WARN  branch $branch has no upstream — nothing to pull"
    exit 0
fi

if [ "$before" = "$upstream" ]; then
    echo "  $OK  already up to date"
    exit 0
fi

ahead=$(git rev-list --count "$upstream..HEAD")
behind=$(git rev-list --count "HEAD..$upstream")

if [ "$ahead" -gt 0 ]; then
    echo "  $FAIL  local branch is $ahead commit(s) ahead of $upstream"
    echo "${DIM}  push, rebase, or reset before running update${RESET}"
    exit 1
fi

if $dry_run; then
    echo "  $SKIP  would fast-forward $behind commit(s)"
    echo ""
    echo "${BOLD}Would-be changes${RESET}"
    git diff --name-only "$before" "$upstream" | sed 's/^/  /'
    exit 0
fi

echo "  ${DIM}fast-forwarding $behind commit(s)...${RESET}"
if ! git merge --ff-only --quiet "$upstream"; then
    echo "  $FAIL  fast-forward failed"
    exit 1
fi
after=$(git rev-parse HEAD)
echo "  $OK  ${before:0:7} → ${after:0:7} ($behind commit(s))"

# Show changed files
echo ""
echo "${BOLD}Changed files${RESET}"
changed=$(git diff --name-only "$before" "$after")
if [ -z "$changed" ]; then
    echo "  ${DIM}(none)${RESET}"
else
    echo "$changed" | sed 's/^/  /'
fi

# Post-pull: re-sync anything that's copied (not live-sourced) from the repo
echo ""
echo "${BOLD}Apply${RESET}"

if echo "$changed" | grep -qx "custom.zsh-theme"; then
    ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
    if [ -d "$ZSH_CUSTOM/themes" ]; then
        if cp "$ZSH_CONFIG_DIR/custom.zsh-theme" "$ZSH_CUSTOM/themes/custom.zsh-theme"; then
            echo "  $OK  theme re-synced to $ZSH_CUSTOM/themes/"
        else
            echo "  $FAIL  theme copy failed"
            exit 1
        fi
    else
        echo "  $WARN  custom.zsh-theme changed but $ZSH_CUSTOM/themes missing — run 'zc fix'"
    fi
else
    echo "  $SKIP  theme unchanged"
fi

echo ""
echo "${DIM}Everything else is sourced live from the repo — run 'exec zsh' to reload.${RESET}"
