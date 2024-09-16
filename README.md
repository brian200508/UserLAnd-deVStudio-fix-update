
# Install Proot-Distro debian with XFCE4/Termux X11, Chromium and VSCode

Install Termux Proot-Distro (XFCE4-Desktop) with Termux:x11 support.
For better convenience additionally some developer stuff like Chromium, Git, Python3 and Node.JS is installed.

## UserLAnd

- Install [__Termux__](https://github.com/termux/termux-app/releases) Android app from [__GitHub__](https://github.com/termux).
- Install [__Termux X11__](https://github.com/termux/termux-app/releases) Android app from [__GitHub__](https://github.com/termux/termux-x11/releases).
- In the terminal clone this repo and run script:
```bash
cd ~ && termux-setup-storage && pkg update -y && pkg install -y git && git clone https://github.com/brian200508/proot-distro-debian-termux-x11.git /sdcard/proot-distro-debian-termux-x11.git && cd /sdcard/proot-distro-debian-termux-x11 && chmod +x install-debian.sh && ./install-debian.sh && cd ~
```
