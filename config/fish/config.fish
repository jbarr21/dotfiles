if status is-interactive
  atuin init fish --disable-ctrl-r | source
  if type -q mise; and not set -q MISE_SHELL
    mise activate fish | source
  end
  # Commands to run in interactive sessions can go here
end
