export VISUAL=vim
export EDITOR=$VISUAL

# awesome cd movements from zshkit
setopt autocd autopushd pushdminus pushdsilent pushdtohome cdablevars
DIRSTACKSIZE=5

# Enable extended globbing
setopt extendedglob

# Allow [ or ] whereever you want
unsetopt nomatch

# Colors

# makes color constants available
autoload -U colors
colors

# enable colored output from ls, etc. on FreeBSD-based systems
export CLICOLOR=1
export BAT_THEME="OneHalfDark"

# To opt in to Homebrew analytics, `unset` this in ~/.zshrc.local .
export HOMEBREW_NO_ANALYTICS=1
