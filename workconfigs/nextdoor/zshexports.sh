export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion


DATABRICKS_INTERACTIVE_TOKEN=$(cat ~/.databricks/workspaces/interactive/token.txt)
DATABRICKS_INTERACTIVE_UC_TOKEN=$(cat ~/.databricks/workspaces/interactive-uc/token.txt)
DATABRICKS_INTERACTIVE_HOST=$(cat ~/.databricks/workspaces/interactive/host.txt)
DATABRICKS_INTERACTIVE_UC_HOST=$(cat ~/.databricks/workspaces/interactive-uc/host.txt)
DATABRICKS_INTERACTIVE_METASTORE_ID=$(cat ~/.databricks/workspaces/interactive/metastore_id.txt)
DATABRICKS_INTERACTIVE_UC_METASTORE_ID=$(cat ~/.databricks/workspaces/interactive-uc/metastore_id.txt)
