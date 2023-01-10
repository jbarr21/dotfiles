# Ubuntu-only stuff. Abort if not Ubuntu.
is_ubuntu || return 1

sudo apt update;
cat $DOTFILES/conf/packages/apt | xargs sudo apt install --assume-yes;