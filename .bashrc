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

alias cp="cp -i"
alias mv="mv -i"
alias rm="rm -i"

alias update-grub="grub-mkconfig -o /boot/grub/grub.cfg"
alias bashrc="source ~/.bashrc"

# Show fan RPM and CPU celsius
alias heat="sensors | grep -E 'Package id 0|fan' | awk -F':' '{print \$1 \" =>\" \$2}'"

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias ip='ip -color=auto'

alias dotfiles='git --git-dir=$HOME/.dotfiles --work-tree=$HOME'