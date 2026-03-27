#!/bin/zsh

GITCONFIG_SRC="$ZSH_CONFIG_DIR/gitconfig"
GITCONFIG_DST="$HOME/.gitconfig"

if [ ! -f "$GITCONFIG_SRC" ]; then
    echo "Error: gitconfig not found at $GITCONFIG_SRC"
    exit 1
fi

# back up old .gitconfig file
if [ -f "$GITCONFIG_DST" ]; then
    t=$(date +%s)
    echo "Creating backup of old .gitconfig file to .gitconfig.bak.$t"
    cp "$GITCONFIG_DST" "$GITCONFIG_DST.bak.$t"
fi

# copy gitconfig
cp "$GITCONFIG_SRC" "$GITCONFIG_DST"
echo "Git config applied to $GITCONFIG_DST"
