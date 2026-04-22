#!/bin/zsh

if [ -z "$ZSH_CONFIG_DIR" ]; then
    # Infer from script location
    ZSH_CONFIG_DIR="$(cd "$(dirname "$0")/.." && pwd)"
fi

# Parse optional --append flag
APPEND_MODE=0
if [ "$1" = "--append" ]; then
    APPEND_MODE=1
    shift
fi

# Check if already configured (protects both overwrite and append modes)
if [ -f "$HOME/.zshrc" ] && grep -qF "source $ZSH_CONFIG_DIR/zshrc.sh" "$HOME/.zshrc"; then
    echo "Zsh config is already set up (found source line in ~/.zshrc)."
    echo "To force reinstall, remove ~/.zshrc and run again."
    exit 0
fi

if [ "$APPEND_MODE" -eq 1 ]; then
    # Append mode: preserve existing .zshrc and add the zshconfig stanza at the end
    cat >> "$HOME/.zshrc" <<EOF

# Added by zc setup --append
export ZSH_CONFIG_DIR=$ZSH_CONFIG_DIR
export PATH=\$ZSH_CONFIG_DIR:\$PATH
source \$ZSH_CONFIG_DIR/zshrc.sh
EOF
    echo "Zsh config appended to existing ~/.zshrc. Please restart your terminal."
    echo "Warning: conflicting configurations are possible — the appended stanza runs after your existing ~/.zshrc, so earlier PATH changes or plugin managers may shadow these additions."
else
    # Default mode: back up any existing .zshrc and overwrite
    if [ -f "$HOME/.zshrc" ]; then
        t=$(date +%s)
        echo "Creating backup of old .zshrc file to ~/.zshrc.bak.$t"
        mv "$HOME/.zshrc" "$HOME/.zshrc.bak.$t"
    fi

    cat > "$HOME/.zshrc" <<EOF
export ZSH_CONFIG_DIR=$ZSH_CONFIG_DIR
export PATH=\$ZSH_CONFIG_DIR:\$PATH
source \$ZSH_CONFIG_DIR/zshrc.sh
EOF
    echo "Zsh config setup complete. Please restart your terminal."
fi

echo ""
echo "To use work configs:"
echo "  zc workconfig list                 List work configs"
echo "  zc workconfig create <name>        Create a new work config"
echo "  zc workconfig activate <name>      Activate a work config"
echo "  zc workconfig deactivate <name>    Deactivate a work config"
