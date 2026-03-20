#!/usr/bin/env bash

set -euo pipefail

error() {
    echo "Error: script failed at line $1" >&2
    # cleanup here if needed
    exit 1
}
trap 'error $LINENO' ERR

echo "Building additional utils..."

# wvkbd
if [ ! -d wvkbd ]; then
	git clone https://github.com/jjsullivan5196/wvkbd.git &>/dev/null
fi
if [ ! -f /usr/local/bin/wvkbd* ]; then
	cd wvkbd
	make
	sudo make install
	cd ..
fi

echo "[INFO] utilities: wvkbd installed successfully"

# sysmenu
if [ ! -d sysmenu ]; then
	git clone https://github.com/System64fumo/sysmenu.git &>/dev/null
fi
if [ ! -f /usr/local/bin/sysmenu ]; then
	cd sysmenu
	make
	sudo make install
	cd ..
fi

echo "[INFO] utilities: sysmenu installed successfully"

# lisgd
if [ ! -d lisgd ]; then
	git clone https://git.sr.ht/~mil/lisgd &>/dev/null
fi
if [ ! -f /usr/bin/lisgd ]; then
	cd lisgd
	make
	sudo make install
	cd ..
fi

echo "[INFO] utilities: lisgd installed successfully"

# # hyprgrass plugin
# hyprpm update --no-shallow
# hyprpm add https://github.com/horriblename/hyprgrass.git
# hyprpm enable hyprgrass
# hyprpm reload

# hyprshot
if [ ! -d Hyprshot ]; then
	git clone https://github.com/Gustash/hyprshot.git Hyprshot &>/dev/null
fi
ln -sf $(pwd)/Hyprshot/hyprshot /usr/bin/hyprshot &>/dev/null
sudo chmod +x Hyprshot/hyprshot

echo "[INFO] utilities: hyprshot installed successfully"

echo "Utilities are installed correctly!"

# echo "[INFO] configuration: copying the configuration..."
