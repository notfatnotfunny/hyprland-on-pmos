#!/usr/bin/env bash

set -euo pipefail

error() {
    echo "Error: script failed at line $1" >&2
    # cleanup here if needed
    exit 1
}
trap 'error $LINENO' ERR

echo "Building Hyprland from source..."


# hyprutils
if [ ! -d hyprutils ]; then
	git clone https://github.com/hyprwm/hyprutils.git &>/dev/null
fi
cd hyprutils/
cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_INFO_PREFIX:PATH=/usr -S . -B ./build
cmake --build ./build --config Release --target all -j`nproc 2>/dev/null || getconf NPROCESSORS_CONF`
sudo cmake --install build
cd ..

echo "[INFO] Hyprland: hyprutils installed successfully"

# hyprgraphics
if [ ! -d hyprgraphics ]; then
	git clone https://github.com/hyprwm/hyprgraphics &>/dev/null
fi
cd hyprgraphics/
cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_INFO_PREFIX:PATH=/usr -S . -B ./build
cmake --build ./build --config Release --target all -j`nproc 2>/dev/null || getconf NPROCESSORS_CONF`
sudo cmake --install build
cd ..

echo "[INFO] Hyprland: hyprgraphics installed successfully"

# seatd
if [ ! -d seatd ]; then
	git clone https://git.sr.ht/~kennylevinsen/seatd &>/dev/null
fi
cd seatd
meson setup build
ninja -C build
sudo ninja -C build install
cd ..

echo "[INFO] Hyprland: seatd installed successfully"

# hyprtoolkit
if [ ! -d hyprtoolkit ]; then
	git clone https://github.com/hyprwm/hyprtoolkit.git &>/dev/null
fi
cd hyprtoolkit
cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_INFO_PREFIX:PATH=/usr -S . -B ./build
cmake --build ./build --config Release --target all -j`nproc 2>/dev/null || getconf NPROCESSORS_CONF`
sudo cmake --install ./build
cd ..

echo "[INFO] Hyprland: hyprtoolkit installed successfully"

# hyprwayland-scanner
if [ ! -d hyprwayland ]; then
	git clone https://github.com/hyprwm/hyprwayland-scanner.git &>/dev/null 
fi
cd hyprwayland-scanner
cmake -DCMAKE_INFO_PREFIX=/usr -B build
cmake --build build -j `nproc`
sudo cmake --install build
cd ..

echo "[INFO] Hyprland: hyprwayland-scanner installed successfully"

# aquamarine
if [ ! -d aquamarine ]; then
	git clone https://github.com/hyprwm/aquamarine.git &>/dev/null 
fi
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


cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_INFO_PREFIX:PATH=/usr -S . -B ./build
cmake --build ./build --config Release --target all -j`nproc 2>/dev/null || getconf _NPROCESSORS_CONF`
sudo cmake --install build
cd ..

echo "[INFO] Hyprland: aquamarine installed successfully"

# hyprlang
if [ ! -d hyprlang ]; then
	git clone https://github.com/hyprwm/hyprlang.git &>/dev/null 
fi
cd hyprlang
cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_INFO_PREFIX:PATH=/usr -S . -B ./build
cmake --build ./build --config Release --target hyprlang -j`nproc 2>/dev/null || getconf _NPROCESSORS_CONF`
sudo cmake --install ./build
cd ..

echo "[INFO] Hyprland: hyprlang installed successfully"

# hyprcursor
if [ ! -d hyprcursor ]; then
	git clone https://github.com/hyprwm/hyprcursor.git &>/dev/null
fi
cd hyprcursor
cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_INFO_PREFIX:PATH=/usr -S . -B ./build
cmake --build ./build --config Release --target all -j`nproc 2>/dev/null || getconf _NPROCESSORS_CONF`
sudo cmake --install build
cd ..

echo "[INFO] Hyprland: hyprcursor installed successfully"

# wayland-protocols
if [ ! -d wayland ]; then
	git clone https://gitlab.freedesktop.org/wayland/wayland-protocols.git &>/dev/null 
fi
cd wayland-protocols
mkdir build
cd build
meson setup --prefix=/usr --buildtype=release ..
ninja
sudo ninja install
cd ../..

echo "[INFO] Hyprland: wayland-protocols installed successfully"

# libxkbcommon
if [ ! -d libxkbcommon ]; then
	git clone https://github.com/xkbcommon/libxkbcommon.git &>/dev/null 
fi
cd libxkbcommon
meson setup build \
      -Denable-x11=false \
      -Dxkb-config-root=/usr/share/X11/xkb \
      -Dx-locale-root=/usr/share/X11/locale
meson compile -C build
sudo meson install -C build
cd ..

echo "[INFO] Hyprland: libxkbcommon installed successfully"

# hyprwire
if [ ! -d hyprwire ]; then
	git clone https://github.com/hyprwm/hyprwire.git &>/dev/null 
fi
cd hyprwire
cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_INFO_PREFIX:PATH=/usr -S . -B ./build
cmake --build ./build --config Release --target all -j`nproc 2>/dev/null || getconf NPROCESSORS_CONF`
sudo cmake --install build
cd ..

echo "[INFO] Hyprland: hyprwire installed successfully"

# glaze
if [ ! -d glaze ]; then
	git clone https://github.com/stephenberry/glaze.git &>/dev/null 
fi
cd glaze
sudo systemctl start docker
sudo docker pull ubuntu:24.04
sudo docker run --rm \
  --network host \
  -v $(pwd):/src \
  -w /src \
  ubuntu:24.04 bash -c "
    apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y cmake g++ ninja-build libasan8 openssl libssl-dev && \
    mkdir build && cd build && \
    cmake .. && \
    make -j\$(nproc) && \
    cmake --install . --prefix /src/install
  "
cp -r install/include/* /usr/local/include/
cp -r install/share/* /usr/local/share/
cd ..

echo "[INFO] Hyprland: glaze installed successfully"

# Hyprland
if [ ! -d Hyprland ]; then
	git clone https://github.com/hyprwm/Hyprland.git &>/dev/null 
fi
cd Hyprland
make all
sudo make install
cd ..

echo "[INFO] Hyprland: Hyprland installed successfully"



echo "Building additional utils..."

# wvkbd
if [ ! -d wvkbd ]; then
	git clone https://github.com/jjsullivan5196/wvkbd.git &>/dev/null
fi
cd wvkbd
make
sudo make install
cd ..

echo "[INFO] utilities: wvkbd installed successfully"

# sysmenu
if [ ! -d sysmenu ]; then
	git clone https://github.com/System64fumo/sysmenu.git &>/dev/null
fi
cd sysmenu
make
sudo make install
cd ..

echo "[INFO] utilities: sysmenu installed successfully"

# # hyprgrass plugin
# hyprpm update --no-shallow
# hyprpm add https://github.com/horriblename/hyprgrass.git
# hyprpm enable hyprgrass
# hyprpm reload

# hyprshot
if [ ! -d -s ]; then
	git clone https://github.com/Gustash/hyprshot.git Hyprshot &>/dev/null
fi
ln -s $(pwd)/Hyprshot/hyprshot /usr/bin/hyprshot
sudo chmod +x Hyprshot/hyprshot

echo "[INFO] utilities: hyprshot installed successfully"

echo "[INFO] configuration: copying the configuration..."

cp -rf hyprland-on-pmos/dots/* ~/.config/

echo "the installation is complete!"
