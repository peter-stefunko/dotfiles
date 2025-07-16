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
alias st="spicetify"

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
alias waybar-reload="pkill waybar && sway exec waybar"

alias rofi-config="sudo nano $XDG_CONFIG_HOME/rofi/config.rasi"
alias foot-config="sudo nano $XDG_CONFIG_HOME/foot/foot.ini"
alias wez-config="sudo nano $XDG_CONFIG_HOME/wezterm/wezterm.lua"

# Functions
yay-autoremove() {
  yay -Rn $(yay -Qdtq)
}

yayr() {
  [ -z "$1" ] && echo "Enter package name" && return
  yay -Rns $(yay -Qq | grep "^$1")
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

# Default prompt
PS1='[\u@\h \W]\$ '

eval "$(dircolors -b ~/.dircolors)"

sep=""
git_end_sep="\[\e[38;5;173m\]$sep\[\e[0m\]"
git_yes_sep="\[\e[48;5;173;38;5;15m\]$sep\[\e[0m\]"
git_not_sep="\[\e[38;5;15m\]$sep\[\e[0m\]"

getBranch() {
  # Only continue if we're in a Git repository
  git rev-parse --is-inside-work-tree &>/dev/null || { echo ""; return; }

  # Get branch name or short commit hash
  ref=$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)

  # Get status
  git_status=$(git status --porcelain=2 --branch 2>/dev/null)
  ab_status=$(echo "$git_status" | awk -F '^# branch.ab ' '{print $2}')

  # Check for ahead/behind info
  ahead=$(echo "$ab_status" | awk '{print $1}')
  behind=$(echo "$ab_status" | awk '{print $2}')
  remote_status=""

  if [ "$ahead" -gt 0 ]; then
    remote_status=" $ahead";
  fi

  if [ "$behind" -lt 0 ]; then
    remote_status="$remote_status $behind";
  fi

  # Indicators
  dirty=""
  staged=""
  untracked=""
  echo "$git_status" | grep '^1 ' &>/dev/null && staged="+"
  echo "$git_status" | grep '^2 ' &>/dev/null && dirty="*"
  echo "$git_status" | grep '^? ' &>/dev/null && untracked="?"
  status="$staged$dirty$untracked"

  if [[ -n "$status" ]]; then
    status=" $status";
  fi

  # Build full status
  echo " $ref$remote_status$status"
}

export PS1="\
\[\e[48;5;137;38;5;255;1m\] \u \[\e[0m\]\
\[\e[48;5;180;38;5;137m\]$sep\[\e[0m\]\
\[\e[48;5;180;38;5;242;1m\] \h \[\e[0m\]\
\[\e[48;5;15;38;5;180m\]$sep\[\e[0m\]\
\[\e[48;5;15;38;5;242;1m\] \W \[\e[0m\]\
$git_yes_sep\
\[\e[48;5;173;38;5;255;1m\] \$(getBranch) \[\e[0m\]\\
$git_end_sep "

export PS1="\n$PS1"

##-----------------------------------------------------
## synth-shell-prompt.sh
#if [ -f /home/peter/.config/synth-shell/synth-shell-prompt.sh ] && [ -n "$( echo $- | grep i )" ]; then
#	source /home/peter/.config/synth-shell/synth-shell-prompt.sh
#fi

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
