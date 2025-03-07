# /bin/zsh

# KUBE PS1
KUBE_PS1_SYMBOL_ENABLE=false
KUBE_PS1_CTX_COLOR=90
KUBE_PS1_BG_COLOR=0

#AWS
SHOW_AWS_PROMPT=false

#PYTHON
export PYTHON_VENV_DIRECTORY="$HOME/dev/.venvs"
mkdir -p $PYTHON_VENV_DIRECTORY

# Exports used by workon function in zshfunctions.sh
# use pyenv by default
export DEFAULT_PYENV=0
export ACTIVE_PYENV=""
# use venvs in $PYTHON_VENV_DIRECTORY by default
export DEFAULT_VENV=1

export PYTHONPATH=.
# pyenv config
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

# Mysql
export PATH="/opt/homebrew/opt/mysql-client/bin:$PATH"

#Kafka
export C_INCLUDE_PATH=/opt/homebrew/Cellar/librdkafka/2.5.0/include/
export LIBRARY_PATH=/opt/homebrew/Cellar/librdkafka/2.5.0/lib

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Ruby
export PATH=/opt/homebrew/Cellar/ruby/3.3.1/bin/:$PATH

# FZF
export FZF_DEFAULT_OPTS="--history=$HOME/.fzf-history"

# autojump
[ -f /opt/homebrew/etc/profile.d/autojump.sh ] && . /opt/homebrew/etc/profile.d/autojump.sh

# Pipx
export PATH="$PATH:/Users/wadeseidule/.local/bin"