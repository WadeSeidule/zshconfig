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
        echo "Usage: workon [. | env_name | poetry]"
        echo "Arguments:"
        echo '. : Activate the virtual env in the current directory (.venv)'
        echo "env_name: optional, Name of the virtual env to activate"
        echo "poetry: optional, Activate the poetry virtual env"
    elif [ $1 = "." ];
    then
      # Activate the virtual env in the current directory
      # works for uv, virtualenv, venv, poetry
      if [ -d ".venv" ];
      then
        source .venv/bin/activate
        which python
      else
        echo "Could not find .venv in the current directory"
      fi
    elif [ $1 = "poetry" ];
    then
        source "$( poetry env list --full-path | grep Activated | cut -d' ' -f1 )/bin/activate"
        which python
    #if pyenv is enabled and $1 is a pyenv version
    elif [ $DEFAULT_PYENV -eq 1 ];
    then
      if [ $(pyenv versions | grep -c $1) -ge 1 ];
      then
        pyenv deactivate 2>/dev/null
        pyenv activate $1
        export ACTIVE_PYENV=$1
      else
        echo "Could not find pyenv version $1"
      fi
    elif [ $DEFAULT_VENV -eq 1 ];
    then
      if [ -d "$PYTHON_VENV_DIRECTORY/$1" ];
      then
        source "$PYTHON_VENV_DIRECTORY/$1/bin/activate"
        which python
      else
        echo "Could not find virtual env $1"
      fi
    else
      echo "Could not determine which virtual env to use"
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

  # Create the virtual environment
  if [ "$DEFAULT_PYENV" -eq 1]; then
    echo "Creating virtualenv with pyenv"
    if [ -n "$py_version" ]; then
      pyenv virtualenv "$py_version" "$venv_name"
    else
      pyenv virtualenv "$venv_name"
    fi
  elif [ "$DEFAULT_VENV" -eq 1 ]; then
    echo "Creating virtualenv with uv"
    if [ -d "$PYTHON_VENV_DIRECTORY/$venv_name" ]; then
      echo "Virtual env $venv_name already exists"
    else
      if [ -n "$py_version" ]; then
        uv venv -p "$py_version" "$PYTHON_VENV_DIRECTORY/$venv_name"
      else
        uv venv "$PYTHON_VENV_DIRECTORY/$venv_name"
      fi
    fi
  else
    echo "Could not determine which virtualenv creation method to use."
    echo "Set DEFAULT_PYENV or DEFAULT_VENV in zshexports.sh."
    return 1
  fi
}

function venv_deactivate() {
  if [  ]
}