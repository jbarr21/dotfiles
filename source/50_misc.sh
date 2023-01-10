# Change file extensions recursively in current directory
#
#   change-extension erb haml

function change-extension() {
  foreach f (**/*.$1)
    mv $f $f:r.$2
  end
}

# Load .env file into shell session for environment variables

function envup() {
  if [ "$#" -eq 1 ] && [ -f "$1" ]; then
    export $(sed '/^ *#/ d' "$1")
  elif if [ -f .env ]; then
    export $(sed '/^ *#/ d' .env)
  else
    echo 'No .env file found' 1>&2
    return 1
  fi
}

# Make directory and change into it.

function mcd() {
  mkdir -p "$1" && cd "$1";
}

alias zbench='for i in {1..10}; do /usr/bin/time zsh -lic exit; done'
