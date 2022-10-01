# Unix
alias ll="ls -al"
alias llt='ls -lat'
alias ln="ln -v"
alias mkdir="mkdir -p"
alias path='echo $PATH | tr -s ":" "\n"'
alias rl='source ~/.zshrc; echo ".zshrc reloaded"'
alias e="$EDITOR"
alias v="$VISUAL"

function _bat() { _cat "$@"; };
function _exa() { _ls "$@"; };

alias agc='ag --noheading --nofilename --nobreak -o'
alias ags='ag-sorted'
alias cat='bat'
alias chpwd='exa --git --icons --classify --group-directories-first --time-style=long-iso --group --color-scale'
alias du="ncdu --color dark -rr"
alias fpp='fpp --python2'
alias lcase='tr "[:upper:]" "[:lower:]"'
alias ls='exa'
alias md2gd='pbpaste | pandoc -f markdown+smart -t html | pbcopy; swift ~/dotfiles/bin/pbAsHtml.swift; echo "Copied to clipboard";'
alias ping='~/dotfiles/bin/prettyping --nolegend'
alias preview="fzf --preview 'bat --color \"always\" {}'"
alias rgc='rg -oN --no-filename --no-heading'
alias top="htop"
alias tree='exa --tree'
alias ucase='tr "[:lower:]" "[:upper:]"'

# Apps
alias dex2jar='d2j-dex2jar'
alias luyten='JAVA_HOME=$JDK_18 open -a /Applications/Luyten.app'
alias stree='open -a /Applications/Sourcetree.app'
alias ofd='open_command'
alias macdown='open -a MacDown'

# Misc
alias notifyDone='terminal-notifier -title "Terminal" -message "Done with task!" -sound default'
alias avd='JAVA_HOME="$JDK_18" avdmanager list avds | grep -oe "Name: .*" | sed "s/Name: //" | fzf | xargs -I {} sh -c "emulator -avd {} &"'

OS=$(uname)
case $OS in
  'Linux')
    alias fd='fdfind'
    alias ls='ls --color=auto -p'
    alias sagi='sudo apt-get install'
    alias sai='sudo apt install'
    alias sagu='sudo apt-get update'
    alias saar='sudo add-apt-repository'
    alias sagr='sudo apt-get remove'
    alias pbcopy='xclip -selection c'
    alias pbpaste='xclip -selection clipboard -o'
    ;;
  'Darwin')
    ;;
  *) ;;
esac

# Include custom aliases
if [[ -f ~/.aliases.local ]]; then
  source ~/.aliases.local
fi
