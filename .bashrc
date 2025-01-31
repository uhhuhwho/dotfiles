#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

# For PKG to be found
export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH

# Alias
alias vim='nvim'
alias vi='nvim'

alias dotfiles='git --git-dir=$HOME/.dotfiles --work-tree=$HOME'