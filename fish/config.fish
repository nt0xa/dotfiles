# XDG Base Directory Specification {{{ #
# https://wiki.archlinux.org/title/XDG_Base_Directory

set -gx XDG_CONFIG_HOME $HOME/.config
set -gx XDG_DATA_HOME $HOME/.local/share
set -gx XDG_STATE_HOME $HOME/.local/state
set -gx XDG_CACHE_HOME $HOME/.cache
set -gx XDG_RUNTIME_DIR $HOME/.cache

# }}} XDG Base Directory Specification #

# Locale and Editors {{{ #

set -gx LANG en_US.UTF-8
set -gx LC_ALL $LANG
set -gx PAGER less
set -gx EDITOR nvim
set -gx VISUAL nvim

# }}} Locale and Editors #

# Path {{{ #

fish_add_path -p $HOME/.local/bin
fish_add_path -p /opt/homebrew/bin

set -gp fish_complete_path $XDG_DATA_HOME/fish/completions

# Path }}} #

# Settings {{{ #

# History
set -gx fish_history_size 100000

# Disable greeting message
set -g fish_greeting 

# Nord theme for fish
fish_config theme choose Nord

# }}} Settings #

# External Tool Integrations {{{ #

# Starship: Modern cross-shell prompt
type -q starship && starship init fish | source

# OrbStack: Container management integration
test -f ~/.orbstack/shell/init.fish && source ~/.orbstack/shell/init.fish

# }}} External Tool Integrations #

# Key Bindings {{{ #

bind \ct kill-line             # Ctrl+T: Delete to line end
bind \cg edit_command_buffer   # Ctrl+G: Edit in $EDITOR

# }}} Key Bindings #

# Aliases {{{ #

alias v='nvim'
alias now="date '+%Y-%m-%d_%H-%M'"

# }}} Aliases #

# vim: foldmethod=marker foldmarker={{{,}}}
