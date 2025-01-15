# Amazon Q pre block. Keep at the top of this file.
[[ -f "${HOME}/Library/Application Support/amazon-q/shell/zshrc.pre.zsh" ]] && builtin source "${HOME}/Library/Application Support/amazon-q/shell/zshrc.pre.zsh"

# Path to zsh config dir
ZSH_CONFIG_DIR=$ZSH_CONFIG_DIR || "$HOME/.zshconfig"

# binds
bindkey -v

# top level zsh files
find "$ZSH_CONFIG_DIR" -maxdepth 1 -type f -name "zsh*.sh" | while read -r file; do
  # Skips this file or else endless loop
  if [[ "$(basename "$file")" == $(basename $0) ]]; then
        continue
  fi
  source $file
done

# work config zsh files
find "$ZSH_CONFIG_DIR/workconfigs/$WORK_CONFIG" -type f -name "zsh*.sh" | while read -r file; do
  # Skips this file or else endless loop
  if [[ "$(basename "$file")" == $(basename $0) ]]; then
        continue
  fi
  source $file
done
source $ZSH/oh-my-zsh.sh

# pyenv config
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

[[ -f "$HOME/fig-export/dotfiles/dotfile.zsh" ]] && builtin source "$HOME/fig-export/dotfiles/dotfile.zsh"
# Amazon Q post block. Keep at the bottom of this file.
[[ -f "${HOME}/Library/Application Support/amazon-q/shell/zshrc.post.zsh" ]] && builtin source "${HOME}/Library/Application Support/amazon-q/shell/zshrc.post.zsh"
