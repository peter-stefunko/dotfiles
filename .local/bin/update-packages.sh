#!/bin/bash

yay -Q | awk '{print $1}' | grep -v '\-debug$' > ~/.config/pkginstall/packages.txt
