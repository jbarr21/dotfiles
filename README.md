# jbarr21 dotfiles

## Install

For the initial install:

```sh
bash -c "$(wget -qO- https://raw.github.com/jbarr21/dotfiles/main/bin/dotfiles)" && source ~/.zshrc
```

or

```sh
git clone https://github.com/jbarr21/dotfiles.git ~/dotfiles --recursive
~/dotfiles/bin/dotfiles
source ~/.zshrc
```

To update the dotfiles:
```sh
dotfiles
```