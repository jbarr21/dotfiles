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
  zgenom ohmyzsh plugins/z

  [[ "$(uname -s)" = Darwin ]] && zgenom ohmyzsh plugins/macos
  [[ "$(uname -s)" = Darwin ]] && zgenom ohmyzsh plugins/vscode

  zgenom load aloxaf/fzf-tab

  zgenom load zsh-users/zsh-autosuggestions
  zgenom load zsh-users/zsh-syntax-highlighting

  #zgenom load jandamm/zgenom-ext-release
  # Download all assets matching *apple*.
  # Also extract from archive and add to $PATH.
  #zgenom release ajeetdsouza/zoxide --pattern '*apple*'

  # add binaries
  zgenom bin tj/git-extras

  # theme
  zgenom load romkatv/powerlevel10k powerlevel10k

  # save all to init script
  zgenom save

  # Compile your zsh files
  zgenom compile "$HOME/.zshrc"

  # You can perform other "time consuming" maintenance tasks here as well.
  # If you use `zgenom autoupdate` you're making sure it gets
  # executed every 7 days.
fi
