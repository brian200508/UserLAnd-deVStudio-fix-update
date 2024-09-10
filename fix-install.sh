#!/bin/bash 

# Fix vscode.list: Use signed Microsoft Repo
echo "Signing VSCode repository..."
sudo apt install -y wget gpg
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
rm -f packages.microsoft.gpg
sudo apt install -y apt-transport-https
sudo apt update -y

# Intall latest VSCode
echo "Setting up latest VSCode..."
#wget -O ~/code_stable_arm64.deb 'https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-arm64'
#sudo apt install -y ~/code_stable_arm64.deb
#rm ~/code_stable_arm64.deb
#sudo apt update -y
#code --no-sandbox 
sudo apt install -y code # or code-insiders 
sudo apt update -y
#sed -i 's@code --new-window \%F@code --no-sandbox --new-window \%F@g' /usr/share/applications/code.desktop
#sed -i 's@code \%F@code --no-sandbox \%F@g' /usr/share/applications/code.desktop

# Install Chromium Browser
echo "Setting up Chromium Browser..."
sudo apt update -y
sudo apt install -y --reinstall software-properties-common
sudo add-apt-repository ppa:xtradeb/apps -y
sudo apt update -y
sudo apt install -y chromium
sudo apt update -y
#sed -i 's@chromium \%U@chromium --no-sandbox \%U@g' /usr/share/applications/chromium.desktop
#chromium --no-sandbox 

# Git, Python3 and essentials
echo "Setting up Git, Python3 and essentials"
sudo apt update -y
sudo apt install -y build-essential curl git wget pgp python-is-python3 python3-distutils python3-venv python3-pip

# Node.js
echo "Setting up Node.js 20.x-LTS..."
sudo apt update -y
# installs nvm (Node Version Manager)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash
# download and install Node.js (you may need to restart the terminal)
nvm install 20

# fix desktop links
cp ./fix-desktop-links.sh ~/fix-desktop-links.sh
chmod +x ./fix-desktop-links.sh
chmod +x ~/fix-desktop-links.sh
~/fix-desktop-links.sh

# Summary
cd ~
echo "Done."
echo ""
echo "Installed versions:"
chromium --version
code --version
git --version
node --version
npm --version
python --version
echo ""
echo "Don't forget Your Git config:"
echo "    git config --global user.name \"Your Name\""
echo "    git config --global user.email \"your.email-address@domain.com\""
echo ""
echo "After Chromium or VSCode update You can fix the desktop application links"
echo "by running this command:"
echo "    ~/fix-desktop-links.sh"
echo ""
echo "For deVStudio:"
echo "Close VSCode and restart with:"
echo "    code --no-sandbox"
echo "(or re-start deVStudio App)"
echo ""

