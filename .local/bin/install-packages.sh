#!/bin/bash

pkgs="$HOME/.config/pkginstall/packages.txt"

if [[ ! -f "$pkgs" ]]; then
	echo "erro: $pkgs not found"
	exit 1
fi

yay -S --needed $(< "$pkgs")
