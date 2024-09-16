#!/bin/bash 

function yes_or_no {
    while true; do
        read -p "$* [y/n]: " yn
        case $yn in
            [Yy]*) return 0  ;;  
            [Nn]*) echo "Aborted" ; return  1 ;;
        esac
    done
}

# Setup Termux
echo "Setting up Termux..."
termux-setup-storage
pkg update -y
pkg install -y git wget proot-distro
proot-distro install debian

# Setup user
echo "Setting up User..."
proot-distro login debian -- apt update -y
proot-distro login debian -- apt install -y sudo nano adduser -y
proot-distro login debian -- adduser droiduser
proot-distro login debian -- echo "# Add droiduser to sudoers" >> /etc/sudoers
proot-distro login debian -- echo "droiduser ALL=(ALL:ALL) ALL" >> /etc/sudoers

# Install XFCE4
echo "Setting up XFCE4..."
proot-distro login debian --user droiduser -- sudo apt install xfce4

# Install Termux X11
echo "Setting up Termux X11..."
pkg update
pkg install x11-repo
pkg install termux-x11-nightly
pkg install pulseaudio

## Fix vscode.list: Use signed Microsoft Repo
#echo "Signing VSCode repository..."
#proot-distro login debian -- sudo apt install -y wget gpg apt-transport-https
#proot-distro login debian -- wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
#proot-distro login debian -- sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
#proot-distro login debian -- sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
#proot-distro login debian -- rm -f packages.microsoft.gpg
#proot-distro login debian -- sudo apt update -y

# Intall latest VSCode
echo "Setting up latest VSCode..."
proot-distro login debian --user droiduser --shared-tmp -- wget -O /tmp/code_stable_arm64.deb 'https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-arm64'
proot-distro login debian --user droiduser --shared-tmp -- sudo apt install -y /tmp/code_stable_arm64.deb
proot-distro login debian --user droiduser --shared-tmp -- rm /tmp/code_stable_arm64.deb
proot-distro login debian --user droiduser -- sudo apt update -y
#proot-distro login debian --user droiduser -- code --no-sandbox 
#proot-distro login debian --user droiduser -- sed -i 's@code --new-window \%F@code --no-sandbox --new-window \%F@g' /usr/share/applications/code.desktop
#proot-distro login debian --user droiduser -- sed -i 's@code \%F@code --no-sandbox \%F@g' /usr/share/applications/code.desktop

# Install Chromium Browser
echo "Setting up Chromium Browser..."
proot-distro login debian --user droiduser -- sudo apt update -y
#proot-distro login debian --user droiduser -- sudo apt install -y software-properties-common
#proot-distro login debian --user droiduser -- sudo add-apt-repository ppa:xtradeb/apps -y
#vsudo apt update -y
proot-distro login debian --user droiduser -- sudo apt install -y chromium
proot-distro login debian --user droiduser -- sudo apt update -y
#proot-distro login debian --user droiduser -- sed -i 's@chromium \%U@chromium --no-sandbox \%U@g' /usr/share/applications/chromium.desktop
#proot-distro login debian --user droiduser -- chromium --no-sandbox 

# Git, Python3 and essentials
echo "Setting up Git, Python3 and essentials"
proot-distro login debian --user droiduser -- sudo apt update -y
proot-distro login debian --user droiduser -- sudo apt install -y build-essential curl git wget pgp python-is-python3 python3-distutils python3-venv python3-pip

# Node.js
echo "Setting up Node.js 20.x-LTS..."
proot-distro login debian --user droiduser -- sudo apt update -y
# installs nvm (Node Version Manager)
proot-distro login debian --user droiduser -- curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash
#FIXME: . ~/.bashrc
proot-distro login debian --user droiduser -- export NVM_DIR="$HOME/.nvm"
proot-distro login debian --user droiduser -- [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
proot-distro login debian --user droiduser -- [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
# download and install Node.js (you may need to restart the terminal)
proot-distro login debian --user droiduser -- nvm install 20

# fix desktop links
proot-distro login debian --user droiduser -- cp /tmp/fix-desktop-links.sh ~/fix-desktop-links.sh
proot-distro login debian --user droiduser -- chmod +x /tmp/fix-desktop-links.sh
proot-distro login debian --user droiduser -- chmod +x ~/fix-desktop-links.sh
~/fix-desktop-links.sh

# Summary
cd ~
echo "Done."
echo ""
yes_or_no "Delete the cloned Git repo (/tmp/proot-distro-debian-termux-x11)?" && rm -rf /tmp/proot-distro-debian-termux-x11
echo ""
echo "Installed versions:"
proot-distro login debian -- chromium --version
proot-distro login debian -- code --version
proot-distro login debian -- git --version
proot-distro login debian -- node --version
proot-distro login debian -- npm --version
proot-distro login debian -- nvm --version
proot-distro login debian -- python --version
echo ""
echo "Don't forget Your Git config:"
echo "    git config --global user.name \"Your Name\""
echo "    git config --global user.email \"your.email-address@domain.com\""
echo ""
echo "After Chromium or VSCode update You can fix the desktop application links"
echo "by running this command:"
echo "    ~/fix-desktop-links.sh"
echo ""
cd ~
