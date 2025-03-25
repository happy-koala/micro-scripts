#!/bin/bash

WORK_TIME=25
SHORT_BREAK=5
LONG_BREAK=25
CYCLES=4

WHITE='\033[37m'
GREEN='\033[32m'
RESET='\033[0m'

play_sound() {
  echo -ne "\a"
}

progress_bar() {
  local duration=$(( $1 * 60 ))
  local steps=$(( duration / 30 ))
  local bar_length=$(( $1 * 2 ))

  # initialize progress
  local progress="${WHITE}$(printf '|%.0s' $(seq 1 $bar_length))${RESET}"
  echo -ne "\r$progress"

  for ((i = 1; i <= steps; i++)); do
    sleep 30 || true

    local progress_length=$(( (i * bar_length) / steps ))

    if ((progress_length == bar_length)); then
      progress="${GREEN}$(printf '|%.0s' $(seq 1 $bar_length))${RESET}"
    else
      progress="${GREEN}$(printf '|%.0s' $(seq 1 $progress_length))${WHITE}$(printf '|%.0s' $(seq 1 $((bar_length - progress_length))))${RESET}"
    fi

    echo -ne "\r$progress"
  done

  echo "" 
}

# start timer
cycle_count=0
while true; do
  echo -e "Work: $WORK_TIME Minutes"
  progress_bar $WORK_TIME

  ((cycle_count++))

  # start break
  play_sound  

  if ((cycle_count % CYCLES == 0)); then
    echo "Long Break: $LONG_BREAK Minutes"
    progress_bar $LONG_BREAK
  else
    echo "Short Break: $SHORT_BREAK Minutes"
    progress_bar $SHORT_BREAK
  fi

  play_sound
  sleep 0.05
  play_sound
  sleep 0.05
  play_sound
done