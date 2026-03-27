export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"                                       # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" # This loads nvm bash_completion

[ -f ~/.databricks/workspaces/interactive/token.txt ] && export DATABRICKS_INTERACTIVE_TOKEN=$(cat ~/.databricks/workspaces/interactive/token.txt) && export DATABRICKS_TOKEN=$DATABRICKS_INTERACTIVE_TOKEN
[ -f ~/.databricks/workspaces/interactive-uc/token.txt ] && export DATABRICKS_INTERACTIVE_UC_TOKEN=$(cat ~/.databricks/workspaces/interactive-uc/token.txt)
[ -f ~/.databricks/workspaces/interactive/host.txt ] && export DATABRICKS_INTERACTIVE_HOST=$(cat ~/.databricks/workspaces/interactive/host.txt)
[ -f ~/.databricks/workspaces/interactive-uc/host.txt ] && export DATABRICKS_INTERACTIVE_UC_HOST=$(cat ~/.databricks/workspaces/interactive-uc/host.txt)
[ -f ~/.databricks/workspaces/interactive/metastore_id.txt ] && export DATABRICKS_INTERACTIVE_METASTORE_ID=$(cat ~/.databricks/workspaces/interactive/metastore_id.txt)
[ -f ~/.databricks/workspaces/interactive-uc/metastore_id.txt ] && export DATABRICKS_INTERACTIVE_UC_METASTORE_ID=$(cat ~/.databricks/workspaces/interactive-uc/metastore_id.txt)

export DATAFLOW_DAGS_PATH="$HOME/dev/dataflow-dags"
export DATAFLOW_PATH="$HOME/dev/dataflow"

# k8s
export STAGING_ANALYTICS1="staging-analytics1"
export ANALYTICS1="analytics1"

export PATH="$PATH:$HOME/dev/data-snippets/bin"
# export PATH="$PATH:$DATAFLOW_PATH/bin"

export CLAUDE_CODE_USE_BEDROCK=0

# DD keys sourced from local secrets file
if [ -f "$HOME/.dd_keys" ]; then
  source "$HOME/.dd_keys"
fi

source "$DATAFLOW_PATH/dataflow_cli/completions/dataflow_completions.sh"
