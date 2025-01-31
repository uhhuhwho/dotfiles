#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

# auto start x at login - https://wiki.archlinux.org/title/Xinit#Autostart_X_at_login
if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
  exec startx
fi
