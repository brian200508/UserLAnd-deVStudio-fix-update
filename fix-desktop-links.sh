#!/bin/bash

echo "Fix desktop links"
echo "Updating..."
sudo apt update -y

echo "Fixing VSCode desktop links..."
sed -i 's@code --new-window \%F@code --no-sandbox --new-window \%F@g' /usr/share/applications/code.desktop
sed -i 's@code --new-window \%f@code --no-sandbox --new-window \%f@g' /usr/share/applications/code.desktop
sed -i 's@code \%F@code --no-sandbox \%F@g' /usr/share/applications/code.desktop
sed -i 's@code \%f@code --no-sandbox \%f@g' /usr/share/applications/code.desktop

echo "Fixing Chromium desktop links..."
sed -i 's@chromium \%U@chromium --no-sandbox \%U@g' /usr/share/applications/chromium.desktop
sed -i 's@chromium \%u@chromium --no-sandbox \%u@g' /usr/share/applications/chromium.desktop

echo "Fixing Web Browser desktop links..."
sed -i 's@WebBrowser \%U@WebBrowser --no-sandbox \%U@g' /usr/share/applications/xfce4-web-browser.desktop
sed -i 's@WebBrowser \%u@WebBrowser --no-sandbox \%u@g' /usr/share/applications/xfce4-web-browser.desktop

echo "Done."
