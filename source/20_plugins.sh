source "${HOME}/.zgenom/zgenom.zsh"

if ! zgenom saved; then
  zgenom ohmyzsh

  # completions
  zgenom ohmyzsh plugins/adb
  zgenom ohmyzsh plugins/ag
  zgenom ohmyzsh plugins/asdf
  zgenom ohmyzsh plugins/bazel
  zgenom ohmyzsh plugins/fd
  zgenom ohmyzsh plugins/httpie
  zgenom ohmyzsh plugins/ripgrep
  zgenom load zsh-users/zsh-completions
  zgenom load jandamm/zgenom-ext-eval
  zgenom load jandamm/zgenom-ext-release
  zgenom load jandamm/zgenom-ext-run

  # plugins
  zgenom ohmyzsh plugins/colored-man-pages
  zgenom ohmyzsh plugins/extract
  zgenom ohmyzsh plugins/gh
  zgenom ohmyzsh plugins/git
  zgenom load unixorn/fzf-zsh-plugin
  zgenom ohmyzsh plugins/fzf
  # zgenom ohmyzsh plugins/jira
  zgenom ohmyzsh plugins/rsync
  # zgenom ohmyzsh plugins/vi-mode
  zgenom ohmyzsh plugins/web-search
  zgenom ohmyzsh plugins/zoxide

  [[ "$(uname -s)" = Darwin ]] && zgenom ohmyzsh plugins/macos
  [[ "$(uname -s)" = Darwin ]] && zgenom ohmyzsh plugins/vscode

  zgenom load aloxaf/fzf-tab

  zgenom load zsh-users/zsh-autosuggestions
  zgenom load zsh-users/zsh-syntax-highlighting

  # add binaries
  zgenom bin tj/git-extras

  # core apps
  test -d "$HOME/bin" && mkdir -p "$HOME/bin" || true
  command -v eget > /dev/null 2>&1 || (bash "$HOME/dotfiles/scripts/eget.sh" && mv $HOME/eget $HOME/bin/)

  command -v starship > /dev/null 2>&1 || eget starship/starship
  command -v zoxide > /dev/null 2>&1 || eget ajeetdsouza/zoxide
  command -v atuin > /dev/null 2>&1 || eget atuinsh/atuin

  zgenom eval --name zoxide <<(zoxide init zsh)
  zgenom eval --name atuin <<(atuin init zsh --disable-ctrl-r)

  # theme
  [[ "$JBARR21_USE_STARSHIP" -eq 1 ]] && command -v starship > /dev/null 2>&1 && zgenom eval --name starship <<(starship init zsh)
  [[ "$JBARR21_USE_P10K" -eq 1 ]] && zgenom load romkatv/powerlevel10k powerlevel10k

  # save all to init script
  zgenom save

  # Compile your zsh files
  zgenom compile "$HOME/.zshrc"

  # You can perform other "time consuming" maintenance tasks here as well.
  # If you use `zgenom autoupdate` you're making sure it gets
  # executed every 7 days.
fi
