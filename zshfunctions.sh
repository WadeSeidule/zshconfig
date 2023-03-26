# /bin/zsh

function ssh_kundulab () {
  ssh -p 2220 wseidule@razorback.ceretype.com
}

function automouse () {
  local time_arg_name
  local time_arg=""
  if [ $# -eq 1 ]
  then
    time_arg_name="--time"
    time_arg=$1
  fi

  python ~/dev/scripts/auto_mouse.py $time_arg_name $time_arg
}

function dev () {
  if [ -z "$1" ]; then
    cd ~/dev/
  else
    cd ~/dev && $(fd -d 2 $1 | head -n 1)
  fi
}


function docker_exec () {
  docker exec -it $1 /bin/bash
}


function workon() {
    if [ $# -eq 0 ]
    then
        echo "Please provide venv name"
    elif [ $1 = "venv" ];
    then
        source venv/bin/activate
        which python
    elif [ $1 = "poetry" ];
    then
        source "$( poetry env list --full-path | grep Activated | cut -d' ' -f1 )/bin/activate"
        which python
    else
        source "$PYTHON_VENV_DIRECTORY/$1/bin/activate"
        which python
    fi
}

function pyscript() {
  cp ~/dev/scripts/generic_python_script.py $1
}

function new_venv() {
  if [ $# -eq  ]
  then
      echo "Please provide venv name"
  elif [ $1 = "venv" ];
  then
      python -m venv venv
  else
      python -m venv $PYTHON_VENV_DIRECTORY/$1
  fi
}