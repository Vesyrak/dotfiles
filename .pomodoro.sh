# Dependencies:
# lolcat
#
# MacOS
# brew install caarlos0/tap/timer

declare -A pomo_options
pomo_options["work"]="25"
pomo_options["break"]="5"


pomodoro() {
  val=$1
  echo $val | lolcat
  timer ${pomo_options["$val"]}m
  if [[ $(uname) == "Darwin" ]]; then
    say -v Zarvox "'$val' session done"
    osascript -e 'display notification "☕" with title "'$val' timer is up!" sound name "Crystal"'
  elif command -v apt > /dev/null; then
    spd-say "'$val' session done"
    notify-send --app-name=Pomodoro🍅 "'$val' timer is up! ☕"
  else
    echo 'Unknown OS, but we finished anyway.'
  fi
}

start_pomodoro() {
  # Number of times to repeat the loop, default is 2
  if [ -n "$1" ] && [ "$1" -eq "$1" ] 2>/dev/null; then
    num_loops=$1
  else
   # Default loops
    num_loops=2
  fi

  for i in $(seq 1 $num_loops); do
    pomodoro "work"
    pomodoro "break"
  done
}
change_pomo() {
  if [ -n "$1" ] && [ -n "$2" ]; then
    pomo_options["$1"]="$2"
    echo "The $1 time has been changed to $2 minutes"
  else
    echo "Please provide valid parameters: change_pomo [work/break] [time_in_minutes]"
  fi
}

alias doro="pomodoro 'work'"
alias domo="pomodoro 'break'"
