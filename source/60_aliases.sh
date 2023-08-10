# Unix
alias ll="ls -al"
alias llt='ls -lat'
alias ln="ln -v"
alias mkdir="mkdir -p"
alias path='echo $PATH | tr -s ":" "\n"'
alias rl='source ~/.zshrc; echo ".zshrc reloaded"'
alias e="$EDITOR"
alias v="$VISUAL"

alias agc='ag --noheading --nofilename --nobreak -o'
alias ags='ag-sorted'
alias cat='bat'
alias chpwd='exa --git --icons --classify --group-directories-first --time-style=long-iso --group --color-scale'
alias du="ncdu --color dark -rr"
alias fpp='fpp --python2'
alias lcase='tr "[:upper:]" "[:lower:]"'
alias lg='lazygit'
alias ls='exa'
alias md2gd='pbpaste | pandoc -f markdown+smart -t html | pbcopy; swift ~/dotfiles/bin/pbAsHtml.swift; echo "Copied to clipboard";'
alias ping='~/dotfiles/bin/prettyping --nolegend'
alias preview="fzf --preview 'bat --color \"always\" {}'"
alias rgc='rg -oN --no-filename --no-heading'
alias top="htop"
alias tree='exa --tree'
alias ucase='tr "[:lower:]" "[:upper:]"'

# Git
alias gu='git reset HEAD --'
alias gdiscard='git checkout --'
alias gbls='git for-each-ref --sort=committerdate refs/heads/ --format="%(color: red)%(committerdate:short) %(color: cyan)%(refname:short)" | ag -v "(\/save/|jb\/foo|master|main|tmp\.)"'
alias gblsa='git for-each-ref --sort=committerdate refs/heads/ --format="%(color: red)%(committerdate:short) %(color: cyan)%(refname:short)"'
alias gcof='gbls | fzf | awk '\''{print $2}'\'' | xargs git checkout'
alias gdc='git diff --cached'
alias gdt='git difftool -t Kaleidoscope'
alias gdtc='git difftool -t Kaleidoscope --cached'
alias glone='git log --pretty=format:"%h%x09%<(30)%ae%<(35)%aD%x09%s"' # %x09%an
alias glol='git log --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr)%Creset by %C(bold blue)%an%Creset %C(bold blue)<%ae>%Creset"'
alias glom='git pull origin master'
alias gbc='gbls | gum choose --no-limit --height=25 | cut -f 2 -d " " | xargs git branch -D'
alias wip='git add . && git stash save'

# Build
alias ad='arc diff'
alias af='arc flow'
alias gw='./gradlew'
alias lw='./lintw'
alias fw='./flutterw'
alias dw='./depw'
alias wk='watchman watch-del-all'
alias nukeit='git clean -fdx && watchman watch-del-all && killall java && rm -rf ~/.gradle/caches'
alias rmbuck='rm -rf buck-out; find . -iname "BUCK" -exec rm {} +'

# Apps
alias dex2jar='d2j-dex2jar'
alias luyten='JAVA_HOME=$JDK_18 open -a /Applications/Luyten.app'
alias stree='open -a /Applications/Sourcetree.app'
alias ofd='open_command'
alias macdown='open -a MacDown'

# IP addresses
alias ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias localip="ipconfig getifaddr en0"
alias ips="ifconfig -a | grep -o 'inet6\? \(addr:\)\?\s\?\(\(\([0-9]\+\.\)\{3\}[0-9]\+\)\|[a-fA-F0-9:]\+\)' | awk '{ sub(/inet6? (addr:)? ?/, \"\"); print }'"

# Misc
alias notifyDone='terminal-notifier -title "Terminal" -message "Done with task!" -sound default'
alias avd='emulator -list-avds | fzf | xargs -I {} sh -c "emulator -avd {} -gpu host &"'

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
