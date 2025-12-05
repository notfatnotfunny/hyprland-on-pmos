





sudo apk add git cmake meson pixman-dev cairo-dev pango-dev libjpeg-turbo-dev libwebp-dev librsvg-dev file-dev udis86-git-dev mesa-egl mesa-gles mesa-dev pugixml-dev libseat-dev libinput-dev wayland-dev wayland-protocols-dev libdisplay-info-dev hwdata-dev libzip-dev tomlplusplus-dev bison libxcursor-dev re2-dev muparser-dev xcb-util-wm-dev xcb-util-errors-dev cpio libxcomposite-dev xcb-util-keysyms xcb-util-keysyms-dev libliftoff cpio glaze hyprland-protocols hyprland-qtutils









# [build from source]


# hyprutils
git clone https://github.com/hyprwm/hyprutils.git
cd hyprutils/
cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_INSTALL_PREFIX:PATH=/usr -S . -B ./build
cmake --build ./build --config Release --target all -j`nproc 2>/dev/null || getconf NPROCESSORS_CONF`
sudo cmake --install build
cd ..

# hyprgraphics
git clone https://github.com/hyprwm/hyprgraphics
cd hyprgraphics/
cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_INSTALL_PREFIX:PATH=/usr -S . -B ./build
cmake --build ./build --config Release --target all -j`nproc 2>/dev/null || getconf NPROCESSORS_CONF`
sudo cmake --install build
cd ..


git clone https://github.com/hyprwm/hyprwayland-scanner.git
cd hyprwayland-scanner
cmake -DCMAKE_INSTALL_PREFIX=/usr -B build
cmake --build build -j `nproc`
sudo cmake --install build
cd ..

git clone https://github.com/hyprwm/aquamarine.git
cd aquamarine

tmp=$(mktemp)

while IFS= read -r line; do
	if echo "$line" | grep -q "target_link_libraries(aquamarine OpenGL::EGL OpenGL::OpenGL PkgConfig::deps)"; then
		echo "target_link_libraries(aquamarine PRIVATE GLESv2 EGL PkgConfig::deps)" >> "$tmp"
	elif ! echo "$line" | grep -q "find_package(OpenGL REQUIRED COMPONENTS"; then
		echo "$line" >> "$tmp"
	fi
done < CMakeLists.txt

mv "$tmp" CMakeLists.txt
# remove the line 
#   find_package(OpenGL REQUIRED COMPONENTS "GLES3")  
# and change the line
#   target_link_libraries(aquamarine OpenGL::EGL OpenGL::OpenGL PkgConfig::deps)
#   to
#   target_link_libraries(aquamarine PRIVATE GLESv2 EGL PkgConfig::deps)


cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_INSTALL_PREFIX:PATH=/usr -S . -B ./build
cmake --build ./build --config Release --target all -j`nproc 2>/dev/null || getconf _NPROCESSORS_CONF`
sudo cmake --install build
cd ..

git clone https://github.com/hyprwm/hyprlang.git
cd hyprlang
cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_INSTALL_PREFIX:PATH=/usr -S . -B ./build
cmake --build ./build --config Release --target hyprlang -j`nproc 2>/dev/null || getconf _NPROCESSORS_CONF`
sudo cmake --install ./build
cd ..


git clone https://github.com/hyprwm/hyprcursor.git
cd hyprcursor
cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_INSTALL_PREFIX:PATH=/usr -S . -B ./build
cmake --build ./build --config Release --target all -j`nproc 2>/dev/null || getconf _NPROCESSORS_CONF`
sudo cmake --install build
cd ..


git clone https://gitlab.freedesktop.org/wayland/wayland-protocols.git
cd wayland-protocols
mkdir build
cd build
meson setup --prefix=/usr --buildtype=release ..
ninja
sudo ninja install
cd ../..


git clone https://github.com/xkbcommon/libxkbcommon.git
cd libxkbcommon
meson setup build \
      -Denable-x11=false \
      -Dxkb-config-root=/usr/share/X11/xkb \
      -Dx-locale-root=/usr/share/X11/locale
meson compile -C build
sudo meson install -C build
cd ..

#hyprwire
git clone https://github.com/hyprwm/hyprwire.git
cd hyprwire
cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_INSTALL_PREFIX:PATH=/usr -S . -B ./build
cmake --build ./build --config Release --target all -j`nproc 2>/dev/null || getconf NPROCESSORS_CONF`
sudo cmake --install build
cd ..


# Hyprland
git clone https://github.com/hyprwm/Hyprland.git
cd Hyprland
make all
sudo make install





# cool stuff that works well with hyprland
#
# packaged
sudo apk add alacritty waybar hypridle swaybg jq hyprlock dunst



# to build

# wvkbd
git clone https://github.com/jjsullivan5196/wvkbd.git
cd wvkbd
make
sudo make install
cd ..


# sysmenu
sudo apk add gtkmm4-dev gtk4-layer-shell-dev
git clone https://github.com/System64fumo/sysmenu.git
cd sysmenu
make
sudo make install
cd ..
mkdir /home/$USER/.config/sys64/menu/
# config.conf and style.css

# hyprgrass plugin
sudo apk add glm-dev
hyprpm update --no-shallow
hyprpm add https://github.com/horriblename/hyprgrass.git
hyprpm enable hyprgrass
hyprpm reload

# hyprshot
sudo apk add slurp grim wl-clipboard
git clone https://github.com/Gustash/hyprshot.git Hyprshot
ln -s $(pwd)/Hyprshot/hyprshot /usr/bin/hyprshot
sudo chmod +x Hyprshot/hyprshot


# squeekboard didn't work for me
sudo apk add rustc-dev cargo gnome-desktop-dev libbsd-dev feedbackd-dev
git clone https://gitlab.gnome.org/World/Phosh/squeekboard.git
cd squeekboard
mkdir _build
meson setup _build/
cd _build
ninja
