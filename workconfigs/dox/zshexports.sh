PATH=$PATH:~/.dox:/Users/wadeseidule/.local/bin
export PATH
source ~/.dox/dox_completion.sh

export SNOWFLAKE_USERNAME=wseidule2
export SNOWFLAKE_ROLE=analytics
export SNOWFLAKE_WAREHOUSE=adhoc_wh
export SNOWFLAKE_DATABASE=development
export SNOWFLAKE_SCHEMA=dimm
export SNOWFLAKE_ACCOUNT=doximity.us-east-1.privatelink

test -f /Users/wadeseidule/.doximityrc && source /Users/wadeseidule/.doximityrc