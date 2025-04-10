#!/bin/bash

logfile="$HOME/init.log"

log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*" | tee -a "$logfile"
    "$@" >> "$logfile" 2>&1
}

# Clone dotfiles if not present
if [[ ! -d $HOME/.dotfiles ]]; then
    log echo "Cloning dotfiles..."
    log git clone --bare https://github.com/peter-stefunko/dotfiles.git $HOME/
    log mv .git .dotfiles
    for f in .bashrc .bash_profile .profile .nanorc; do
        [ -f "$f" ] && log mv "$f" "$f.bak"
    done
    log dotfiles checkout
    log rm -f .*.bak
fi

# Add user to system groups
log echo "Adding user to groups..."
groups="network power wireshark nordvpn docker video uucp storage render lp input audio wheel"
for group in $groups; do
    if ! getent group "$group" > /dev/null; then
        log sudo groupadd "$group"
    fi
    log sudo usermod -aG "$group" "$USER"
done

# Ensure user owns their home directory
log echo "Fixing home directory ownership..."
log sudo chown -R "$USER:$USER" "$HOME"

# Create standard user directories
log echo "Creating user directories..."
log mkdir -p $HOME/Desktop $HOME/Documents $HOME/Downloads $HOME/Music $HOME/Pictures $HOME/Projects $HOME/Public $HOME/School $HOME/Templates $HOME/Videos

# Make scripts and services executable
log echo "Making scripts and services executable..."
log chmod +x $HOME/.local/bin/* 2>/dev/null
log chmod +x $HOME/.config/sway/scripts/* $HOME/.config/waybar/scripts/* $HOME/.config/polybar/scripts/* $HOME/.config/syntshell/*.sh $HOME/.config/systemd/user/*.service 2>/dev/null

# Install yay if not present
if ! command -v yay >/dev/null 2>&1; then
    log echo "Installing yay..."
    log sudo pacman -S --needed git base-devel
    log git clone https://aur.archlinux.org/yay.git $HOME/yay
    log cd $HOME/yay
    log makepkg -si --noconfirm
    log cd $HOME/
fi

# Install packages from list
log echo "Installing packages from pkg list..."
pkgfile="$HOME/.config/pkginstall/packages.txt"
if [[ ! -f "$pkgfile" ]]; then
    log echo "Error: $pkgfile not found"
    exit 1
fi
log yay -S --needed --noconfirm --removemake --cleanafter --answerclean All --answerdiff N --answeredit N $(< "$pkgfile")
log yay -Syu --noconfirm --removemake --cleanafter --answerclean All --answerdiff N --answeredit N
log yay -Sc --noconfirm --removemake --cleanafter

# Modify systemd sleep config
log echo "Modifying sleep.conf..."
log sudo sed -i 's/^#\?\s*HibernationDelaySec\s*=.*/HibernationDelaySec=30min/' /etc/systemd/sleep.conf
