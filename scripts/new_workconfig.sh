#!/bin/zsh

if [ -z "$ZSH_CONFIG_DIR" ]; then
    echo "ZSH_CONFIG_DIR is not set"
    exit 1
fi

if [ -z "$1" ]; then
    echo "Please provide a work name"
    exit 1
fi

WORK_CONFIG_DIR="$ZSH_CONFIG_DIR/workconfigs/$1"

# create the directory if it doesn't exist
if [ ! -d "$WORK_CONFIG_DIR" ]; then
    echo "Creating work config directory $WORK_CONFIG_DIR"
    mkdir -p $WORK_CONFIG_DIR
fi

# create zsh files in directory
touch $WORK_CONFIG_DIR/zshfunctions.sh
touch $WORK_CONFIG_DIR/zshaliases.sh
touch $WORK_CONFIG_DIR/zshexports.sh
touch $WORK_CONFIG_DIR/zshsecrets.sh

# make the files executable
chmod +x $WORK_CONFIG_DIR/zshfunctions.sh
chmod +x $WORK_CONFIG_DIR/zshaliases.sh
chmod +x $WORK_CONFIG_DIR/zshexports.sh
chmod +x $WORK_CONFIG_DIR/zshsecrets.sh



