# /bin/zsh

function automouse () {
  python ~/dev/scripts/auto_mouse.py $1
}

function dev () {
  if [ -z "$1" ]; then
    cd ~/dev/
  else
    cd ~/dev && $(fd -d 1 $1 | head -n 1)
  fi
}


function docker_exec () {
  docker exec -it $1 /bin/bash
}


function workon() {
    if [ $1 = "-h" ];
    then
        echo "Usage: workon [. | env_name]"
        echo "Arguments:"
        echo '. : Activate the virtual env in the current directory (.venv)'
        echo "env_name: optional, Name of the virtual env to activate from \$PYTHON_VENV_DIRECTORY"
    elif [ $1 = "." ];
    then
      # Activate the virtual env in the current directory
      if [ -d ".venv" ];
      then
        source .venv/bin/activate
        which python
      else
        echo "Could not find .venv in the current directory"
      fi
    elif [ -d "$PYTHON_VENV_DIRECTORY/$1" ];
    then
      source "$PYTHON_VENV_DIRECTORY/$1/bin/activate"
      which python
    else
      echo "Could not find virtual env $1"
    fi
}

function new_venv() {
  # Initialize variables
  py_version=""
  venv_name=""

  # Parse options
  while getopts ":hp:" opt; do
    case ${opt} in
      h) # Help flag
        echo "Usage: new_venv [-p python_version] <venv_name>"
        return 0
        ;;
      p) # Python version flag
        py_version=$OPTARG
        ;;
      \?) # Invalid option
        echo "Invalid option: -$OPTARG" 1>&2
        return 1
        ;;
      :) # Missing argument for an option
        echo "Option -$OPTARG requires an argument." 1>&2
        return 1
        ;;
    esac
  done

  # Shift positional arguments to exclude processed options
  shift $((OPTIND - 1))

  # Get the positional argument (venv_name)
  venv_name=$1

  if [ -z "$venv_name" ]; then
    echo "Error: Missing required virtual environment name." 1>&2
    echo "Usage: new_venv [-p python_version] <venv_name>"
    return 1
  fi

  # Create the virtual environment with uv
  if [ -d "$PYTHON_VENV_DIRECTORY/$venv_name" ]; then
    echo "Virtual env $venv_name already exists"
  else
    if [ -n "$py_version" ]; then
      uv venv -p "$py_version" "$PYTHON_VENV_DIRECTORY/$venv_name"
    else
      uv venv "$PYTHON_VENV_DIRECTORY/$venv_name"
    fi
  fi
}

function venv_deactivate() {
  deactivate
}


function nvim-config() {
  nvim ~/.config/nvim
}


function activate() {
  # default activation of venv
  source .venv/bin/activate
}
