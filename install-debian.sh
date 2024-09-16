#!/bin/bash

TMP_DIR=/sdcard

R="$(printf '\033[1;31m')"                    
G="$(printf '\033[1;32m')"
Y="$(printf '\033[1;33m')"
B="$(printf '\033[1;34m')"
C="$(printf '\033[1;36m')"                             
W="$(printf '\033[0m')"
BOLD="$(printf '\033[1m')"

function confirmation_y_or_n() {
	 while true; do
        read -p "${R}[${W}-${R}]${Y}${BOLD} $1 ${Y}(y/n) "${W} response
        response="${response:-y}"
        eval "$2='$response'"
        case $response in
            [yY]* )
                echo "${R}[${W}-${R}]${G}Continuing with answer: $response"${W}
				sleep 0.2
                break;;
            [nN]* )
                echo "${R}[${W}-${R}]${C}Skipping this setp"${W}
				sleep 0.2
                break;;
            * )
               	echo "${R}[${W}-${R}]${R}Invalid input. Please enter 'y' or 'n'."${W}
                ;;
        esac
    done

}

function setup_tx11autostart() {
    #if [[ "$zsh_answer" == "y" ]]; then
    #    rc_file=~/.zshrc
    #else
        rc_file=~/.bashrc
    #fi
    #banner
    confirmation_y_or_n "Do you want to start Termux X11 automatically with Termux?" tx11_autostart
    if [[ "$tx11_autostart" == "y" ]]; then
        # check if already configured
        if grep -q "^startxfce4-debian.sh" $rc_file; then
            echo "Termux:X11 start already appended"
        else
            echo '# Start Termux:X11' >> $rc_file
            echo 'if [ $( ps aux | grep -c "termux.x11" ) -gt 1 ]; then echo "X server is already running." ; else startxfce4-debian.sh ; fi' >> $rc_file
            echo "Termux:X11 start add to $rc_file"
        fi
    else
        # check if already configured
        if grep -q "^startxfce4-debian.sh" $rc_file; then
            sed -i "" "/Start Termux:X11/d" $rc_file
            sed -i "" "/startxfce4-debian.sh/d" $rc_file
            echo "Termux:X11 start removed from $rc_file"
        fi
    fi
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
proot-distro login debian -- usermod -aG sudo droiduser
#proot-distro login debian -- echo "# Add droiduser to sudoers" >> /etc/sudoers
#proot-distro login debian -- echo "droiduser ALL=(ALL:ALL) ALL" >> /etc/sudoers

# Install XFCE4
echo "Setting up XFCE4..."
proot-distro login debian --user droiduser -- sudo apt install xfce4
proot-distro login debian --user droiduser -- cp $TMP_DIR/proot-distro-debian-termux-x11/startxfce4-debian.sh ~/startxfce4-debian.sh
proot-distro login debian --user droiduser -- chmod +x $TMP_DIR/proot-distro-debian-termux-x11/startxfce4-debian.sh
proot-distro login debian --user droiduser -- chmod +x ~/startxfce4-debian.sh

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
proot-distro login debian --user droiduser --shared-tmp -- wget -O $TMP_DIR/code_stable_arm64.deb 'https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-arm64'
proot-distro login debian --user droiduser --shared-tmp -- sudo apt install -y $TMP_DIR/code_stable_arm64.deb
proot-distro login debian --user droiduser --shared-tmp -- rm $TMP_DIR/code_stable_arm64.deb
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
proot-distro login debian --user droiduser -- cp $TMP_DIR/proot-distro-debian-termux-x11/fix-desktop-links.sh ~/fix-desktop-links.sh
proot-distro login debian --user droiduser -- chmod +x $TMP_DIR/proot-distro-debian-termux-x11/fix-desktop-links.sh
proot-distro login debian --user droiduser -- chmod +x ~/fix-desktop-links.sh
proot-distro login debian --user droiduser -- ~/fix-desktop-links.sh

# Summary
cd ~
echo "Done."
echo ""
confirmation_y_or_n "Do you want to delete the cloned Git repo ($TMP_DIR/proot-distro-debian-termux-x11)?" delete_cloned_repo 
if [[ "$delete_cloned_repo" == "y" ]]; then
    rm -rf $TMP_DIR/proot-distro-debian-termux-x11
fi
echo ""
echo "Installed versions:"
proot-distro login debian --user droiduser -- chromium --version
proot-distro login debian --user droiduser -- code --version
proot-distro login debian --user droiduser -- git --version
proot-distro login debian --user droiduser -- node --version
proot-distro login debian --user droiduser -- npm --version
proot-distro login debian --user droiduser -- nvm --version
proot-distro login debian --user droiduser -- python --version
echo ""
echo "Don't forget Your Git config:"
echo "    git config --global user.name \"Your Name\""
echo "    git config --global user.email \"your.email-address@domain.com\""
echo ""
echo "After Chromium or VSCode update You can fix the desktop application links"
echo "by running this command:"
echo "    ~/fix-desktop-links.sh"
echo ""
echo "Start XFCE (in Termux - not in Proot-Distro)"
echo "    ~/startxfce4_debian.sh"
echo ""
cd ~
