# /bin/zsh

# get user input for the zshconfig dir
echo "Enter the path to the zsh config directory. Default is $HOME/zshconfig"
read ZSH_CONFIG_DIR

# set work config
echo "Enter name of work config. Default: None"
read WORK_CONFIG

# set the default zsh config dir if the user input is empty
if [ -z "$ZSH_CONFIG_DIR" ]; then
    ZSH_CONFIG_DIR="$HOME/zshconfig"
fi

# check if OMZ is installed
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Oh My Zsh is not installed. Installing now..."
    exit 1
fi


# back up old .zshrc file
if [ -f "$HOME/.zshrc" ]; then
    echo "Creating backup of old .zshrc file"
    mv $HOME/.zshrc $HOME/.zshrc.bak
fi

# create .zshrc file
touch $HOME/.zshrc

# add ZSH_CONFIG_DIR to the .zshrc file
echo "export ZSH_CONFIG_DIR=$ZSH_CONFIG_DIR" >> $HOME/.zshrc

# add WORK_CONFIG to the .zshrc file
echo "export WORK_CONFIG=$WORK_CONFIG" >> $HOME/.zshrc

# source zshrc.sh in the .zshrc file
echo "source $ZSH_CONFIG_DIR/zshrc.sh" >> $HOME/.zshrc

