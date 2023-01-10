# jbarr21 dotfiles

## Requirements

Set zsh as your login shell:

```sh
chsh -s $(which zsh)
```

### OS X Notes

You need to have [XCode](https://developer.apple.com/downloads/index.action?=xcode) or, at the very minimum, the [XCode Command Line Tools](https://developer.apple.com/downloads/index.action?=command%20line%20tools), which are available as a much smaller download.

The easiest way to install the XCode Command Line Tools in OSX 10.9+ is to open up a terminal, type `xcode-select --install` and [follow the prompts](http://osxdaily.com/2014/02/12/install-command-line-tools-mac-os-x/).

## Installation

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