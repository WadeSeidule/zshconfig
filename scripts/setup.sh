#!/bin/zsh

if [ -z "$ZSH_CONFIG_DIR" ]; then
    # Infer from script location
    ZSH_CONFIG_DIR="$(cd "$(dirname "$0")/.." && pwd)"
fi

# Check if already configured
if [ -f "$HOME/.zshrc" ] && grep -qF "source $ZSH_CONFIG_DIR/zshrc.sh" "$HOME/.zshrc"; then
    echo "Zsh config is already set up (found source line in ~/.zshrc)."
    echo "To force reinstall, remove ~/.zshrc and run again."
    exit 0
fi

# Back up old .zshrc file
if [ -f "$HOME/.zshrc" ]; then
    t=$(date +%s)
    echo "Creating backup of old .zshrc file to ~/.zshrc.bak.$t"
    mv "$HOME/.zshrc" "$HOME/.zshrc.bak.$t"
fi

# Create .zshrc file
cat > "$HOME/.zshrc" <<EOF
export ZSH_CONFIG_DIR=$ZSH_CONFIG_DIR
export PATH=\$ZSH_CONFIG_DIR:\$PATH
source \$ZSH_CONFIG_DIR/zshrc.sh
EOF

echo "Zsh config setup complete. Please restart your terminal."
echo ""
echo "To use work configs:"
echo "  zc workconfig list                 List work configs"
echo "  zc workconfig create <name>        Create a new work config"
echo "  zc workconfig activate <name>      Activate a work config"
echo "  zc workconfig deactivate <name>    Deactivate a work config"
