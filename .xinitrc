#!/bin/sh

xinitdir=/etc/X11/xinit

# start some nice programs

if [ -d $xinitdir/xinitrc.d ] ; then
 for f in "$xinitdir/xinitrc.d"/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

# start XFCE4
exec startxfce4