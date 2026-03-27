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
# use venvs in $PYTHON_VENV_DIRECTORY by default
export DEFAULT_VENV=1

export PYTHONPATH=.

# Mysql
export PATH="/opt/homebrew/opt/mysql-client/bin:$PATH"

#Kafka
export C_INCLUDE_PATH=/opt/homebrew/Cellar/librdkafka/2.5.0/include/
export LIBRARY_PATH=/opt/homebrew/Cellar/librdkafka/2.5.0/lib

# NVM — lazy loaded, initializes on first call to nvm/node/npm/npx
export NVM_DIR="$HOME/.nvm"
if [ -d "$NVM_DIR" ]; then
  _zc_load_nvm() {
    unset -f nvm node npm npx 2>/dev/null
    [ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion"
  }
  nvm()  { _zc_load_nvm; nvm "$@" }
  node() { _zc_load_nvm; node "$@" }
  npm()  { _zc_load_nvm; npm "$@" }
  npx()  { _zc_load_nvm; npx "$@" }
fi

# Ruby
export PATH=/opt/homebrew/Cellar/ruby/3.3.1/bin/:$PATH

# FZF
export FZF_DEFAULT_OPTS="--history=$HOME/.fzf-history"

# autojump
[ -f /opt/homebrew/etc/profile.d/autojump.sh ] && . /opt/homebrew/etc/profile.d/autojump.sh

# Pipx
export PATH="$PATH:/Users/wadeseidule/.local/bin"