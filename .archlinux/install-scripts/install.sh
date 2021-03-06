#!/bin/sh
# Simple Arch Linux install scripts, tailored to my use case.

# End the script on any errors
set -e

# Change the working directory to this one
cd "$(dirname "$0")"

# Download the install scripts if they don't exist yet
URL="https://raw.githubusercontent.com/GloverDonovan/dotfiles/master/.archlinux/install-scripts"
[ -f 001-preinstall ]   || curl -L "$URL/001-preinstall" -o 001-preinstall
[ -f 002-install ]      || curl -L "$URL/002-install" -o 002-install
[ -f 003-configure ]    || curl -L "$URL/003-configure" -o 003-configure
[ -f 004-postinstall ]  || curl -L "$URL/004-postinstall" -o 004-postinstall
chmod 755 001-preinstall 002-install 003-configure 004-postinstall

# Prompt for the required information

echo -n "Enter the size (in GiB) to give the primary partition: "
read DISTSIZE

echo -n "Enter a username for the user with sudo rights: "
read USERNAME

echo -n "Enter a hostname for this machine ($USERNAME@_____): "
read HOSTNAME

echo -n "Type YES to enable HiDPI support in the virtual console: "
read HIDPI

echo "-----------------------------------------------------"
echo "Arch Linux will be installed with the settings above."
echo "NOTE: You should not run this script if you do not"
echo "      understand what it does. Bad things may happen."
echo -n "Type YES to continue, or Ctrl+C to abort. "
read CONFIRM

if [ "$CONFIRM" != "YES" ]; then
  echo "YES was not given, exiting..."
  exit
fi

echo "====================================================="
echo "Running install scripts..."

# Run the install scripts
env DISTSIZE="$DISTSIZE"                ./001-preinstall
                                        ./002-install
env HOSTNAME="$HOSTNAME" HIDPI="$HIDPI" ./003-configure
env USERNAME="$USERNAME"                ./004-postinstall

echo "Enter a password for $USERNAME..."
arch-chroot /mnt passwd "$USERNAME"

echo "====================================================="
echo "Done. Now reboot into Arch Linux!"
