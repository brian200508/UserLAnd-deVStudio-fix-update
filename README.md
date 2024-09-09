
# Fix Android app installation and update to latest VSCode

Workarounds for __deVStudio__ Android app in order to repair ```apt update``` and update VSCode to the latest Version.
For better convenience additionally some developer stuff like Git, Python3 and Node.JS is installed.

## Steps

### Install deVStudio

 - Install [__deVStudio__](https://play.google.com/store/apps/details?id=tech.ula.devstudio) Android app from [__Google Play__](https://play.google.com).
   See also [GitHub](https://github.com/CypherpunkArmory/deVStudio).
 - Close VSCode.
 - In the background terminal clone this repo and run script:
```bash
cd ~ && sudo apt update -y && sudo apt install -y git && git clone https://github.com/brian200508/deVStudio-fix-update.git && cd ~/deVStudio-fix-update && chmod +x fix-install.sh && ./fix-install.sh
```

 - restart VSCode:
```bash
code --no-sandbox
```

 - Remove the cloned repo afterwards:
```bash
cd ~ && rm -rf ~/deVStudio-fix-update
```



## Notes

The __deVStudio__ Android app is FOSS.
This app is released under the GPLv3.  The source code can be found here.
This app is not created by the main VS Code development team.  Instead it is an adaptation that allows the Linux version to run on Android.
