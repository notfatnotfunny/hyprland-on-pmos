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

echo "[INFO] configuration: copying the configuration..."

if [ ! -d .config ]; then
	mkdir .config
fi
cp -rf hyprland-on-pmos/dots/* .config/
sudo chown -R $USER .config/hypr/scripts/
sudo chmod +x .config/hypr/scripts/*.sh
sudo chmod +x .config/waybar/scripts/*.sh

# allow $USER to use brightnessctl w/o root privileges if needed
sudo usermod -aG video $USER
sudo chmod g+w /sys/class/backlight/*/brightness
sudo chgrp video /sys/class/backlight/*/brightness
echo "you might have to log out and log back in in order for this to work"
echo "the installation is complete!"
