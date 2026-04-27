#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Don't close shell on ctrl+d
set -o ignoreeof

# Aliases
alias ls='ls --color=auto'
alias grep='grep --color=auto'

alias clean="clear && fastfetch"
#alias imv="imv -d"
alias st="spicetify"

alias bashrc="nano $HOME/.bashrc"
alias bash-profile="nano $HOME/.bash_profile"
alias profile="nano $HOME/.profile"
alias nanorc="nano $HOME/.nanorc"

alias dotfiles="/usr/bin/git --git-dir=$HOME/.dotfiles --work-tree=$HOME"
alias update-grub='sudo grub-mkconfig -o /boot/grub/grub.cfg'

alias sway-config="nano $XDG_CONFIG_HOME/sway/config"
alias sway-reload="sway exec reload"
alias swaylock-config="nano $XDG_CONFIG_HOME/swaylock/config"

alias waybar-config="nano $XDG_CONFIG_HOME/waybar/config"
alias waybar-style="nano $XDG_CONFIG_HOME/waybar/style.css"
alias waybar-reload="pkill waybar && sway exec waybar"

alias rofi-config="nano $XDG_CONFIG_HOME/rofi/config.rasi"
alias foot-config="nano $XDG_CONFIG_HOME/foot/foot.ini"
alias wez-config="nano $XDG_CONFIG_HOME/wezterm/wezterm.lua"

# Functions
yay-autoremove() {
  yay -Rn $(yay -Qdtq)
}

yayr() {
  [ -z "$1" ] && echo "Enter package name" && return
  yay -Rn $(yay -Qq | grep "^$1")
}

dus() {
  [ -n "$1" ] && dir="$1" || dir="."
  du -h "$dir" | sort -h
}

dfh() {
  [ -n "$1" ] && dir="$1" || dir="/home"
  echo "Filesystem      Size  Used Avail Use% Mounted on"
  df -h | grep -m 1 "$dir"
}

clformat() {
  wl-copy $(wl-paste)
}

# Default prompt
PS1='[\u@\h \W]\$ '

eval "$(dircolors -b ~/.dircolors)"

source /usr/share/nvm/init-nvm.sh

# Load custom prompt
#if [ -f "$HOME/.config/custom-prompt.sh" ] && [[ $- == *i* ]]; then
#    source "$HOME/.config/custom-prompt.sh"
#fi

##-----------------------------------------------------
## synth-shell-prompt.sh
if [ -f /home/peter/.config/synth-shell/synth-shell-prompt.sh ] && [ -n "$( echo $- | grep i )" ]; then
	source /home/peter/.config/synth-shell/synth-shell-prompt.sh
fi

##-----------------------------------------------------
## alias
if [ -f /home/peter/.config/synth-shell/alias.sh ] && [ -n "$( echo $- | grep i )" ]; then
	source /home/peter/.config/synth-shell/alias.sh
fi

##-----------------------------------------------------
## better-history
if [ -f /home/peter/.config/synth-shell/better-history.sh ] && [ -n "$( echo $- | grep i )" ]; then
	source /home/peter/.config/synth-shell/better-history.sh
fi

# eval "$(starship init bash)"

# The next line updates PATH for the Google Cloud SDK.
#if [ -f '/home/peter/Downloads/gcloud/google-cloud-sdk/path.bash.inc' ]; then . '/home/peter/Downloads/gcloud/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
#if [ -f '/home/peter/Downloads/gcloud/google-cloud-sdk/completion.bash.inc' ]; then . '/home/peter/Downloads/gcloud/google-cloud-sdk/completion.bash.inc'; fi
