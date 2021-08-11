#!/bin/bash
while true; do
  if [[ "$(osascript zoom-mute-status.scpt)" == "Muted" ]]
  then
    echo -n "red" | nc -4u -w0 localhost 1738
  elif [[ "$(osascript zoom-mute-status.scpt)" == "Unmuted" ]]
  then
    echo -n "green" | nc -4u -w0 localhost 1738
  else
    echo -n "white" | nc -4u -w0 localhost 1738
  fi
sleep 1
done