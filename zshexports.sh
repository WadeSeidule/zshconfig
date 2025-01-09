# /bin/zsh

# KUBE PS1
RPS1='$(kubectx_prompt_info)'s

#PYTHON
export PYTHON_VENV_DIRECTORY="~/venv"
export DEFAULT_PYENV=1
export DEFAULT_VENV=0
export PYTHONPATH=.

export SNOWQA_USAGE_MONITORING=0

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