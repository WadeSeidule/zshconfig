#!/bin/zsh
# Amazon Q pre block. Keep at the top of this file.
[[ -f "${HOME}/Library/Application Support/amazon-q/shell/zshrc.pre.zsh" ]] && builtin source "${HOME}/Library/Application Support/amazon-q/shell/zshrc.pre.zsh"

# Path to zsh config dir
export ZSH_CONFIG_DIR=$ZSH_CONFIG_DIR || "$HOME/.zshconfig"
export PATH=$ZSH_CONFIG_DIR/zc:$PATH

# top level zsh files
find "$ZSH_CONFIG_DIR/default_configs" -maxdepth 1 -type f -name "*.sh" | while read -r file; do
  # Skips this file or else endless loop
  if [[ "$(basename "$file")" == $(basename $0) ]]; then
        continue
  fi
  source $file
done

# work config zsh files
if [ -f "$ZSH_CONFIG_DIR/.active_work_configs" ]; then
  while read -r workconfig; do
    find "$ZSH_CONFIG_DIR/workconfigs/$workconfig" -maxdepth 1 -type f -name "zsh*.sh" | while read -r file; do
      source $file
    done
  done < "$ZSH_CONFIG_DIR/.active_work_configs"
fi

# source ohmyzsh last
source $ZSH_CONFIG_DIR/ohmyzsh.sh

# Amazon Q post block. Keep at the bottom of this file.
[[ -f "${HOME}/Library/Application Support/amazon-q/shell/zshrc.post.zsh" ]] && builtin source "${HOME}/Library/Application Support/amazon-q/shell/zshrc.post.zsh"
