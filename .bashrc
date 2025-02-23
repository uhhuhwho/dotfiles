#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

PS1='[\u@\h \W]\$ '

# For PKG to be found
export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH

# git dotfiles
alias dotfiles='git --git-dir=$HOME/.dotfiles --work-tree=$HOME'
alias gm='dotfiles commit -m'

# Alias
alias cp="cp -i"
alias mv="mv -i"
alias rm="rm -i"
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias ip='ip -color=auto'
alias q='exit'

# Show fan RPM and CPU celsius
# alias heat="sensors | grep -E 'Package id 0|fan' | awk -F':' '{gsub(/Package id 0/, \"CPU Temp\"); gsub(/fan1/, \"FAN 1 (CPU)\"); gsub(/fan2/, \"FAN 2 (GPU)\"); print \$1 \":\" \$2}'"

# Function to display CPU temperature, fan speeds, and GPU temperature
heat()
{
    echo "GPU Temp: $(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader)°C"
    sensors | grep -E 'Package id 0|fan' | awk -F':' '{
        gsub(/Package id 0/, "CPU Temp");
        gsub(/fan1/, "FAN 1 (CPU)");
        gsub(/fan2/, "FAN 2 (GPU)");
        print $1 ": " $2
    }'
}

alias update-grub="grub-mkconfig -o /boot/grub/grub.cfg"
alias bashrc="source ~/.bashrc"

alias vim='nvim'
alias vi='nvim'
alias v='nvim'

alias ff='fastfetch'

alias rs='redshift -O 4500'
alias xrs='redshift -x'