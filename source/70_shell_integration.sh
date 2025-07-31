test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh" || true
test -n "$GHOSTTY_RESOURCES_DIR" && source $GHOSTTY_RESOURCES_DIR/shell-integration/zsh/ghostty-integration || true
