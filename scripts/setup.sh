# /bin/zsh

# back up old .zshrc file
if [ -f "$HOME/.zshrc" ]; then
    t=$(date +%s)
    echo "Creating backup of old .zshrc file to .zshrc.bak.$t"
    mv $HOME/.zshrc $HOME/.zshrc.bak.$t
fi

# create .zshrc file
touch $HOME/.zshrc

# add ZSH_CONFIG_DIR to the .zshrc file
echo "export ZSH_CONFIG_DIR=$ZSH_CONFIG_DIR" >> $HOME/.zshrc

# add PATH to the .zshrc file
echo "export PATH=$ZSH_CONFIG_DIR:\$PATH" >> $HOME/.zshrc

# add WORK_CONFIG to the .zshrc file
echo "export WORK_CONFIG=$WORK_CONFIG" >> $HOME/.zshrc

# source zshrc.sh in the .zshrc file
echo "source $ZSH_CONFIG_DIR/zshrc.sh" >> $HOME/.zshrc

## out message ##
echo "Zsh config setup complete. Please restart your terminal."
echo "To use a work config, run 'workconfig <workname> <create|activate|deactivate>'"

