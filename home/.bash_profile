export PATH="$HOME/.npm-global/bin:$PATH"
export PATH="/usr/sbin:$PATH"
#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc


# Added by Toolbox App
export PATH="$PATH:/home/badreddine/.local/share/JetBrains/Toolbox/scripts"


# Added by LM Studio CLI (lms)
export PATH="$PATH:/home/badreddine/.lmstudio/bin"
# End of LM Studio CLI section


# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

. "$HOME/.local/bin/env"


# Added by Antigravity CLI installer
export PATH="/home/badreddine/.local/bin:$PATH"
