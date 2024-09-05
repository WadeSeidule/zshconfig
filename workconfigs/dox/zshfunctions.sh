function doxvpn() {
  if [ $1 = "stop" ];
  then
    echo "Killing doxvpn"
    kill $(cat /tmp/datavpn_dox-data-dev.pid)
    rm /tmp/datavpn_dox-data-dev.pid
  else
    echo "Running DoxVPN"
    datavpn connect dox-data-dev
  fi
}