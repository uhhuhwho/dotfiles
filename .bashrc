#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

PS1='[\u@\h \W]\$ '

alias bashrc="source ~/.bashrc"

# For PKG to be found
export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH

# git dotfiles
alias dotfiles='git --git-dir=$HOME/.dotfiles --work-tree=$HOME'
# dotfiles git commit, don't forget to add a comment in "".
alias dgc='dotfiles commit -a -m'

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
temp()
{
    echo "GPU Temp: $(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader)°C"

    echo "---"

    echo "CPU(s) scaling MHz: $(lscpu | grep 'CPU(s) scaling MHz' | awk '{print $NF}')"
    echo "CPU(s) scaling GHz: $(awk -v max_mhz=$(lscpu | grep "CPU max MHz" | awk '{print $NF}') -v scale=$(lscpu | grep "CPU(s) scaling MHz" | awk '{print $NF}' | tr -d '%') 'BEGIN {printf "%.2f", (max_mhz * scale / 100) / 1000}') GHz"

    sensors | grep -E 'Package id 0|fan' | awk -F':' '{
        gsub(/Package id 0/, "CPU Temp");
        gsub(/fan1/, "FAN 1 (CPU)");
        gsub(/fan2/, "FAN 2 (GPU)");
        print $1 ": " $2
    }'
}

alias update-grub="sudo grub-mkconfig -o /boot/grub/grub.cfg"

alias v='nvim'
alias sv='sudo nvim'

alias ff='fastfetch'

alias rs='redshift -O 4500'
alias xrs='redshift -x'

# Zswap statistics
alias zsstats='sudo grep -r . /sys/kernel/debug/zswap/'

# Pacman sync refresh upgrade
alias syu="sudo pacman -Syu"

# https://wiki.archlinux.org/title/Pacman/Tips_and_tricks#Removing_unused_packages_(orphans)
# If you want to remove all packages in the list at once, run the command without --print argument.
alias pupd='pacman -Qqd | pacman -Rsu --print -'
alias pqe='pacman -Qe'
alias yqm='yay -Qm'

alias unziptarxf='tar -xf'

alias removebashtemp='rm ~/.bash_history-*.tmp'

# Exampel: sudo mount -t ntfs-3g /dev/sda1 /mnt
# sudo umount /mnt
alias mountntfs='sudo mount -t ntfs-3g'

alias removeunsedflatpaks='flatpak uninstall --unused'