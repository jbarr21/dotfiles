# add support for ctrl+o to open selected file in VS Code
export FZF_DEFAULT_OPTS=""
export FZF_DEFAULT_COMMAND='rg --files --hidden --follow -g "!{.git,node_modules}/*" 2> /dev/null'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS='--preview="$HOME/dotfiles/bin/preview {}" --preview-window=right:60%:wrap'
export FZF_ALT_C_OPTS='--preview="HOME/dotfiles/bin/preview {}" --preview-window=right:60%:wrap'
export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS'
--reverse
--height=50%
--bind="ctrl-o:execute(open -a /Applications/Visual\ Studio\ Code.app {})+abort"'

# fzf-tab
zstyle ":completion:*:git-checkout:*" sort false
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'exa -1 --color=always $realpath'

if [[ ! -z "$DEVPOD_NAME" ]]; then
    # install latest version on devpod
    if [[ ! -f "$HOME/.fzf.zsh" ]]; then
        git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
        echo "y y n " | tr ' ' '\n' | ~/.fzf/install
    fi
    source "$HOME/.fzf.zsh"
    export PATH="$HOME/.fzf/bin:$PATH"
fi
