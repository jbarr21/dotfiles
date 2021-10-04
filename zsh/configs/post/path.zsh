# ensure dotfiles bin directory is loaded first
PATH="$HOME/.bin:/usr/local/sbin:$PATH"

# mkdir .git/safe in the root of repositories you trust
PATH=".git/safe/../../bin:$PATH"

NPM_CONFIG_PREFIX="~/.npm-global"
PATH="~/.npm-global/bin:$PATH"

export -U PATH
