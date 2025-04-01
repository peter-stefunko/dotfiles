#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Aliases
alias ls='ls --color=auto'
alias grep='grep --color=auto'

alias dotfiles="/usr/bin/git --git-dir=$HOME/.dotfiles --work-tree=$HOME"
alias update-grub='sudo grub-mkconfig -o /boot/grub/grub.cfg'
alias yay-autoremove="yay -Rns $(yay -Qdtq)"

alias sway-config="sudo nano $XDG_CONFIG_HOME/sway/config"
alias sway-reload="sway exec reload"
alias swaylock-config="sudo nano $XDG_CONFIG_HOME/swaylock/config"

alias waybar-config="sudo nano $XDG_CONFIG_HOME/waybar/config"
alias waybar-style="sudo nano $XDG_CONFIG_HOME/waybar/style.css"
alias waybar-reload="pkill waybar && sway exec waybar &"

alias rofi-config="sudo nano $XDG_CONFIG_HOME/rofi/config.rasi"
alias foot-config="sudo nano $XDG_CONFIG_HOME/foot/foot.ini"

# Default prompt
PS1='[\u@\h \W]\$ '

##-----------------------------------------------------
## synth-shell-prompt.sh
if [ -f /home/peter/.config/synth-shell/synth-shell-prompt.sh ] && [ -n "$( echo $- | grep i )" ]; then
	source /home/peter/.config/synth-shell/synth-shell-prompt.sh
fi

eval "$(dircolors -b ~/.dircolors)"
