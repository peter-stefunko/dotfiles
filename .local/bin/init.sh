#!/bin/bash

logfile="$HOME/init.log"
log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*" | tee -a "$logfile"
    "$@" >> "$logfile" 2>&1
}

# Add user to system groups
log echo "Adding user to system groups..."
groups="network power wireshark nordvpn docker video uucp storage render lp input audio wheel libvirtd"

for group in $groups; do
    if ! getent group "$group" > /dev/null; then
        log sudo groupadd "$group"
    fi

    log sudo usermod -aG "$group" "$USER"
done

# Create media mount dir
log echo "Creating media mount dir..."
log sudo mkdir -p "/etc/media/$USER"
log sudo chown -R "$USER:$USER" "/etc/media/$USER"

# Clone dotfiles
if [[ ! -d "$HOME/.dotfiles" ]]; then
    log echo "Cloning dotfiles..."
    log git clone --bare https://github.com/peter-stefunko/dotfiles.git "$HOME/"
    log mv "$HOME/.git" "$HOME/.dotfiles"

    for f in .bashrc .bash_profile .profile .nanorc; do
        [ -f "$HOME/$f" ] && log mv "$HOME/$f" "$HOME/$f.bak"
    done

    log dotfiles checkout
    log rm -f "$HOME"/.*.bak
    log source "$HOME/.bash_profile"
fi

# Fix home directory ownership
log echo "Fixing home directory ownership..."
log sudo chown -R "$USER:$USER" "$HOME"

# Create standard directories
log echo "Creating standard user directories..."
log mkdir -p "$HOME"/{Documents,Downloads,Pictures,Projects,School,Videos}

# Make scripts executable
log echo "Making scripts and services executable..."
log chmod +x "$HOME"/.local/bin/* 2>/dev/null
log chmod +x "$HOME"/.config/sway/scripts/* "$HOME"/.config/waybar/scripts/* "$HOME"/.config/polybar/scripts/* "$HOME"/.config/syntshell/*.sh "$HOME"/.config/systemd/user/*.service 2>/dev/null

# Install yay if not available
if ! command -v yay >/dev/null 2>&1; then
    log echo "Installing yay..."
    log sudo pacman -S --needed git base-devel
    log git clone https://aur.archlinux.org/yay.git "$HOME/yay"
    log makepkg -si --noconfirm -D "$HOME/yay"
fi

# Install packages from list
log echo "Installing packages from package list..."
pkgfile="$HOME/.config/pkginstall/packages.txt"

if [[ ! -f "$pkgfile" ]]; then
    log echo "Error: $pkgfile not found"
    exit 1
fi

log yay -S --needed --noconfirm --removemake --cleanafter --answerclean All --answerdiff N --answeredit N $(< "$pkgfile")
log yay -Syu --noconfirm --removemake --cleanafter --answerclean All --answerdiff N --answeredit N
log yay -Sc --noconfirm --removemake --cleanafter

# Configure hibernation
log echo "Modifying sleep.conf for hibernation..."
log sudo sed -i 's/^#\?\s*HibernationDelaySec\s*=.*/HibernationDelaySec=30min/' /etc/systemd/sleep.conf

log echo "Configuring initramfs and GRUB for resume..."
log sudo sed -i '/^HOOKS=/ {/resume/! s/block/& resume/}' /etc/mkinitcpio.conf
log sudo mkinitcpio -P

swap_uuid=$(sudo blkid -t TYPE=swap -o value -s UUID)
log sudo sed -i "/^GRUB_CMDLINE_LINUX_DEFAULT=/ {/resume=UUID=/! s/\\(GRUB_CMDLINE_LINUX_DEFAULT=\\\"[^\\\"]*\\)/\\1 resume=UUID=$swap_uuid/}" /etc/default/grub
log sudo grub-mkconfig -o /boot/grub/grub.cfg

# Apply greetd config
log echo "Applying greetd configuration..."
log sudo cp -r "$HOME/.config/greetd" /etc/

# Update timedatectl
log echo "Updating timedatectl config..."
log sudo timedatectl set-timezone Europe/Bratislava
log sudo timedatectl set-ntp true

# Prompt for reboot
read -rp "System setup complete. Reboot now? [y/N]: " reboot_confirm

if [[ "$reboot_confirm" =~ ^[Yy]$ ]]; then
    log echo "Rebooting system..."
    log sudo reboot
else
    log echo "Reboot skipped. Please reboot manually to apply all changes."
fi
