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
alias imv="imv -d"

alias bashrc="sudo nano $HOME/.bashrc"
alias bash-profile="sudo nano $HOME/.bash_profile"
alias profile="sudo nano $HOME/.profile"
alias nanorc="sudo nano $HOME/.nanorc"

alias dotfiles="/usr/bin/git --git-dir=$HOME/.dotfiles --work-tree=$HOME"
alias update-grub='sudo grub-mkconfig -o /boot/grub/grub.cfg'

alias sway-config="sudo nano $XDG_CONFIG_HOME/sway/config"
alias sway-reload="sway exec reload"
alias swaylock-config="sudo nano $XDG_CONFIG_HOME/swaylock/config"

alias waybar-config="sudo nano $XDG_CONFIG_HOME/waybar/config"
alias waybar-style="sudo nano $XDG_CONFIG_HOME/waybar/style.css"
alias waybar-reload="pkill waybar && sway exec waybar &"

alias rofi-config="sudo nano $XDG_CONFIG_HOME/rofi/config.rasi"
alias foot-config="sudo nano $XDG_CONFIG_HOME/foot/foot.ini"

# Functions
yay-autoremove() {
  yay -Rns $(yay -Qdtq)
}

# Default prompt
PS1='[\u@\h \W]\$ '

eval "$(dircolors -b ~/.dircolors)"

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
