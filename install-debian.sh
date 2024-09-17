#!/bin/bash

R="$(printf '\033[1;31m')"                    
G="$(printf '\033[1;32m')"
Y="$(printf '\033[1;33m')"
B="$(printf '\033[1;34m')"
C="$(printf '\033[1;36m')"                             
W="$(printf '\033[0m')"
BOLD="$(printf '\033[1m')"

function banner() {
clear
echo "${Y} █▀▄ █▀▀ █▄   ▀ ▄▀▄  ▄   ▀█▀ █▀▀ █▀█ █▀▄▀█ █░█ ▀▄▀   ▀▄▀ ▄▀█ ▄▀█  "${W}
echo "${Y} █▄▀ ██▄ █▄▀ ░█ █▀█ █░█  ░█░ ██▄ █▀▄ █░▀░█ █▄█ █░█   █░█  ░█  ░█  "${W}
echo
echo "${C}${BOLD} Install Proot-Distro Debian with XFCE4/Termux X11 in Termux"${W}
echo
}

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

function wait_for_key() {
  echo "${C}Press any key to continue"${W}
  while [ true ] ; do
    read -t 3 -n 1
    if [ $? = 0 ] ; then
      break ;
    fi
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
            #echo 'if [ $( ps aux | grep -c "termux.x11" ) -gt 1 ]; then echo "X server is already running." ; else startxfce4-debian.sh ; fi' >> $rc_file
            echo '~/startxfce4-debian.sh &' >> $rc_file
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
banner
echo "${G}${BOLD} Setting up Termux..."${W}
pkg update -y
termux-setup-storage
pkg update -y
pkg install -y git wget 
pkg update -y
pkg install -y proot-distro
wait_for_key

## Setup nerd fonts
#banner
#echo "${G}${BOLD} Setting up nerd fonts..."${W}
#cd ~
#pkg install -y clang git make
#git clone https://github.com/notflawffles/termux-nerd-installer.git
#cd termux-nerd-installer
#rm -rf termux-nerd-installer
#make install
#cd ~
#termux-nerd-installer i jetbrains-mono-ligatures
#termux-nerd-installer s jetbrains-mono-ligatures
##termux-nerd-installer l i

# Setup Debian
banner
echo "${G}${BOLD} Setting up Proot-Distro Debian..."${W}
proot-distro install debian
wait_for_key

# Setup user
banner
echo "${G}${BOLD} Setting up User..."${W}
proot-distro login debian -- apt update -y
proot-distro login debian -- apt install -y sudo nano adduser
proot-distro login debian -- adduser droiduser
proot-distro login debian -- sed -i '$ a # Add droiduser to sudoers' /etc/sudoers
proot-distro login debian -- sed -i '$ a droiduser ALL=(ALL:ALL) ALL' /etc/sudoers
wait_for_key

# Install XFCE4
banner
echo "${G}${BOLD} Setting up Proot-Distro XFCE4..."${W}
proot-distro login debian --user droiduser -- sudo apt install -y xfce4
curl -Lf https://raw.githubusercontent.com/brian200508/proot-distro-debian-termux-x11/main/startxfce4-debian.sh -o ~/startxfce4-debian.sh
chmod +x ~/startxfce4-debian.sh
wait_for_key

# Install Termux X11
banner
echo "${G}${BOLD} Setting up Termux X11..."${W}
pkg update -y
pkg install -y x11-repo
pkg install -y termux-x11-nightly
pkg install -y pulseaudio
wait_for_key

## Fix vscode.list: Use signed Microsoft Repo
#banner
#echo "${G}${BOLD} Signing VSCode repository..."${W}
#proot-distro login debian -- sudo apt install -y wget gpg apt-transport-https
#proot-distro login debian -- wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
#proot-distro login debian -- sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
#proot-distro login debian -- sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
#proot-distro login debian -- rm -f packages.microsoft.gpg
#proot-distro login debian -- sudo apt update -y
#wait_for_key

# Intall latest VSCode
banner
echo "${G}${BOLD} Setting up latest VSCode..."${W}
proot-distro login debian --user droiduser -- wget -O ~/code_stable_arm64.deb 'https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-arm64'
proot-distro login debian --user droiduser -- sudo apt install -y ~/code_stable_arm64.deb
proot-distro login debian --user droiduser -- rm ~/code_stable_arm64.deb
proot-distro login debian --user droiduser -- sudo apt update -y
#proot-distro login debian --user droiduser -- code --no-sandbox 
#proot-distro login debian --user droiduser -- sed -i 's@code --new-window \%F@code --no-sandbox --new-window \%F@g' /usr/share/applications/code.desktop
#proot-distro login debian --user droiduser -- sed -i 's@code \%F@code --no-sandbox \%F@g' /usr/share/applications/code.desktop
wait_for_key

# Install Chromium Browser
banner
echo "${G}${BOLD} Setting up Chromium browser..."${W}
proot-distro login debian --user droiduser -- sudo apt update -y
#proot-distro login debian --user droiduser -- sudo apt install -y software-properties-common
#proot-distro login debian --user droiduser -- sudo add-apt-repository ppa:xtradeb/apps -y
#vsudo apt update -y
proot-distro login debian --user droiduser -- sudo apt install -y chromium
proot-distro login debian --user droiduser -- sudo apt update -y
#proot-distro login debian --user droiduser -- sed -i 's@chromium \%U@chromium --no-sandbox \%U@g' /usr/share/applications/chromium.desktop
#proot-distro login debian --user droiduser -- chromium --no-sandbox
wait_for_key

# Git, Python3 and essentials
banner
echo "${G}${BOLD} Setting up Git, Python3 and essentials..."${W}
proot-distro login debian --user droiduser -- sudo apt update -y
proot-distro login debian --user droiduser -- sudo apt install -y build-essential curl git wget pgp python-is-python3 python3-distutils python3-venv python3-pip
wait_for_key

# Node.js
banner
echo "${G}${BOLD} Setting up Node.js..."${W}
proot-distro login debian --user droiduser -- sudo apt update -y
proot-distro login debian --user droiduser -- sudo apt install -y nodejs npm
wait_for_key

# fix desktop links
banner
echo "${G}${BOLD} Fixing desktop links..."${W}
proot-distro login debian --user droiduser -- curl -Lf https://raw.githubusercontent.com/brian200508/proot-distro-debian-termux-x11/main/fix-desktop-links.sh -o ~/fix-desktop-links.sh
proot-distro login debian --user droiduser -- chmod +x ~/fix-desktop-links.sh
wait_for_key

banner
echo "${G}${BOLD} Setting up X11 autostart..."${W}
setup_tx11autostart

echo ""
echo "${G}${BOLD} Removing installer script..."${W}
rm -f ~/install-debian.sh
wait_for_key

# Summary
banner
echo "${G}${BOLD} Setting up Proot-Distro Debian ${Y}done${G}."${W}
cd ~
echo "${G}Installed versions:"${W}
proot-distro login debian --user droiduser -- chromium --version
proot-distro login debian --user droiduser -- code --version
proot-distro login debian --user droiduser -- git --version
proot-distro login debian --user droiduser -- node --version
proot-distro login debian --user droiduser -- npm --version
proot-distro login debian --user droiduser -- python --version
echo ""
echo "${G}Don't forget Your Git config:"${W}
echo "    ${Y}git config --global user.name \"Your Name\""${W}
echo "    ${Y}git config --global user.email \"your.email-address@domain.com\""${W}
echo ""
echo "${G}After Chromium or VSCode update You can fix the desktop application links"${W}
echo "${G}by running this command (in Proot-Distro):"${W}
echo "    ${C}curl -Lf https://raw.githubusercontent.com/brian200508/proot-distro-debian-termux-x11/main/fix-desktop-links.sh -o ~/fix-desktop-links.sh${G} once"${W}
echo "    ${C}chmod +x ~/fix-desktop-links.sh{G} once"${W}
echo "    ${Y}~/fix-desktop-links.sh"${W}
echo ""
echo "${G}Start XFCE (in Termux - ${Y}not in Proot-Distro!!!${G})"${W}
echo "    ${Y}~/startxfce4_debian.sh"${W}
echo ""
wait_for_key
echo ""
echo "${C}Starting Termux X11 right now..."${W}
source ~/.bashrc
cd ~
