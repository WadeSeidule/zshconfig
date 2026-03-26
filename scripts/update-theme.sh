#!/bin/zsh

if [ -z "$ZSH_CONFIG_DIR" ]; then
    echo "Error: ZSH_CONFIG_DIR is not set."
    exit 1
fi

SRC="$ZSH_CONFIG_DIR/custom.zsh-theme"
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
DEST="$ZSH_CUSTOM/themes/custom.zsh-theme"

if [ ! -f "$SRC" ]; then
    echo "Error: Theme source not found at $SRC"
    exit 1
fi

if [ ! -d "$ZSH_CUSTOM/themes" ]; then
    mkdir -p "$ZSH_CUSTOM/themes"
fi

cp "$SRC" "$DEST"
echo "Theme updated. Run 'exec zsh' to reload."
