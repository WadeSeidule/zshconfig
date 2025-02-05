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

## create ##
if [ "$2" = "create" ]; then
    # if exists, exit
    if [ -d "$WORK_CONFIG_DIR" ]; then
        echo "Work config directory $WORK_CONFIG_DIR already exists"
        exit 1
    fi
    echo "Creating work config directory $WORK_CONFIG_DIR"
    mkdir -p $WORK_CONFIG_DIR
    touch $WORK_CONFIG_DIR/zshfunctions.sh
    touch $WORK_CONFIG_DIR/zshaliases.sh
    touch $WORK_CONFIG_DIR/zshexports.sh
    touch $WORK_CONFIG_DIR/zshsecrets.sh
    chmod +x $WORK_CONFIG_DIR/zshfunctions.sh
    chmod +x $WORK_CONFIG_DIR/zshaliases.sh
    chmod +x $WORK_CONFIG_DIR/zshexports.sh
    chmod +x $WORK_CONFIG_DIR/zshsecrets.sh
    exit 0
fi

## activate ##
if [ "$2" = "activate" ]; then
    if [ ! -d "$WORK_CONFIG_DIR" ]; then
        echo "Work config directory $WORK_CONFIG_DIR does not exist"
        exit 1
    fi
    # add workconfig name to .active_work_configs file
    echo $1 >> $ZSH_CONFIG_DIR/.active_work_configs
    exit 0
fi

## deactivate ##
if [ "$2" = "deactivate" ]; then
    if [ ! -d "$WORK_CONFIG_DIR" ]; then
        echo "Work config directory $WORK_CONFIG_DIR does not exist"
        exit 1
    fi
    if [ ! -f "$ZSH_CONFIG_DIR/.active_work_configs" ]; then
        echo "No active work configs found"
        exit 1
    fi
    # remove workconfig name from .active_work_configs file
    sed "s/^$1\$//g; /^$/d;" $ZSH_CONFIG_DIR/.active_work_configs > /tmp/active_tmp && mv /tmp/active_tmp $ZSH_CONFIG_DIR/.active_work_configs
    exit 0
fi

## list ##
if [ "$1" = "list" ]; then
    echo "Active work configs:"
    if [ ! -f "$ZSH_CONFIG_DIR/.active_work_configs" ]; then
        echo "None"
    else
        cat $ZSH_CONFIG_DIR/.active_work_configs
    fi
    echo "All work configs:"
    ls -1 $ZSH_CONFIG_DIR/workconfigs
    exit 0
fi

function help_message() {
    echo "Usage: workconfig.sh <workname> <create|activate|deactivate|list>"
}

## help ##
if [ "$2" = "help" ]; then
    help_message
    exit 0
fi

## bad input ##
echo "Invalid input"
help_message
exit 1








