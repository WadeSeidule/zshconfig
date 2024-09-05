# /bin/zsh

find "$ZSH_CONFIG_DIR" -type f -name "zsh*.sh" | while read -r file; do
    echo "Making $file executable"
    chmod +x $file
done

ZSH_CONFIG_DIR="$(pwd)"
ZSHRC_PATH="$HOME/.zshrc"

# Check if ~/.zshrc exists
if [ ! -f "$ZSHRC_PATH" ]; then
    touch $ZSHRC_PATH
    echo "# /bin/zsh" >> $ZSHRC_PATH
    chmod +x $ZSHRC_PATH
fi

echo "source $ZSH_CONFIG_DIR/zshrc.sh" >> $ZSHRC_PATH
echo "ZSH config setup complete and added to $ZSHRC_PATH"