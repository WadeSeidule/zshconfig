#!/bin/zsh

if [ -z "$ZSH_CONFIG_DIR" ]; then
    echo "ZSH_CONFIG_DIR is not set"
    exit 1
fi

ACTIVE_FILE="$ZSH_CONFIG_DIR/.active_work_configs"

function help_message() {
    echo "Usage: zc workconfig <action> [name]"
    echo ""
    echo "Actions:"
    echo "  list                  List all and active work configs"
    echo "  create <name>         Create a new work config"
    echo "  activate <name>       Activate a work config"
    echo "  deactivate <name>     Deactivate a work config"
    echo "  edit <name>           Open a work config in your editor"
    echo "  help                  Show this help message"
}

if [ -z "$1" ]; then
    help_message
    exit 1
fi

ACTION="$1"
NAME="$2"

## list ##
if [ "$ACTION" = "list" ]; then
    echo "Active work configs:"
    if [ -f "$ACTIVE_FILE" ] && [ -s "$ACTIVE_FILE" ]; then
        cat "$ACTIVE_FILE"
    else
        echo "  (none)"
    fi
    echo ""
    echo "All work configs:"
    ls -1 "$ZSH_CONFIG_DIR/workconfigs"
    exit 0
fi

## help ##
if [ "$ACTION" = "help" ] || [ "$ACTION" = "--help" ] || [ "$ACTION" = "-h" ]; then
    help_message
    exit 0
fi

# All remaining actions require a name
if [ -z "$NAME" ]; then
    echo "Error: Missing work config name."
    help_message
    exit 1
fi

WORK_CONFIG_DIR="$ZSH_CONFIG_DIR/workconfigs/$NAME"

## create ##
if [ "$ACTION" = "create" ]; then
    if [ -d "$WORK_CONFIG_DIR" ]; then
        echo "Work config '$NAME' already exists at $WORK_CONFIG_DIR"
        exit 1
    fi
    echo "Creating work config '$NAME' at $WORK_CONFIG_DIR"
    mkdir -p "$WORK_CONFIG_DIR"
    touch "$WORK_CONFIG_DIR/zshfunctions.sh"
    touch "$WORK_CONFIG_DIR/zshaliases.sh"
    touch "$WORK_CONFIG_DIR/zshexports.sh"
    touch "$WORK_CONFIG_DIR/zshsecrets.sh"
    chmod +x "$WORK_CONFIG_DIR/zshfunctions.sh"
    chmod +x "$WORK_CONFIG_DIR/zshaliases.sh"
    chmod +x "$WORK_CONFIG_DIR/zshexports.sh"
    chmod +x "$WORK_CONFIG_DIR/zshsecrets.sh"
    exit 0
fi

## activate ##
if [ "$ACTION" = "activate" ]; then
    if [ ! -d "$WORK_CONFIG_DIR" ]; then
        echo "Work config '$NAME' does not exist"
        exit 1
    fi
    # Check if already active
    if [ -f "$ACTIVE_FILE" ] && grep -qxF "$NAME" "$ACTIVE_FILE"; then
        echo "Work config '$NAME' is already active"
        exit 0
    fi
    echo "$NAME" >> "$ACTIVE_FILE"
    echo "Activated '$NAME'. Run 'exec zsh' to reload."
    exit 0
fi

## deactivate ##
if [ "$ACTION" = "deactivate" ]; then
    if [ ! -d "$WORK_CONFIG_DIR" ]; then
        echo "Work config '$NAME' does not exist"
        exit 1
    fi
    if [ ! -f "$ACTIVE_FILE" ]; then
        echo "No active work configs found"
        exit 1
    fi
    tmp=$(mktemp)
    grep -vxF "$NAME" "$ACTIVE_FILE" > "$tmp" && mv "$tmp" "$ACTIVE_FILE"
    echo "Deactivated '$NAME'. Run 'exec zsh' to reload."
    exit 0
fi

## edit ##
if [ "$ACTION" = "edit" ]; then
    if [ ! -d "$WORK_CONFIG_DIR" ]; then
        echo "Work config '$NAME' does not exist"
        exit 1
    fi
    ${EDITOR:-code} "$WORK_CONFIG_DIR"
    exit 0
fi

## bad input ##
echo "Error: Unknown action '$ACTION'"
help_message
exit 1
