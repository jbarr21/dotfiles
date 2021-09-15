#!/bin/bash
while true; do
  if [[ "$(osascript ~/dotfiles/bin/zoom-mute-status.scpt)" == "muted" ]]
  then
    echo -n "red" | nc -4u -w0 localhost 1738
  elif [[ "$(osascript ~/dotfiles/bin/zoom-mute-status.scpt)" == "unmuted" ]]
  then
    echo -n "green" | nc -4u -w0 localhost 1738
  else
    echo -n "white" | nc -4u -w0 localhost 1738
  fi
sleep 1
done