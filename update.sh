#!/usr/bin/env bash

set -euo pipefail

error() {
    echo "Error: script failed at line $1" >&2
    # cleanup here if needed
    exit 1
}
trap 'error $LINENO' ERR

sudo apk update
sudo apk upgrade

echo "Updating Hyprland..."

tmp="tmp.txt"

# hyprutils
if [ -d hyprutils ]; then
	cd hyprutils/
	git pull &>"$tmp"
	if ! grep -q "Already up to date." "$tmp"; then
		cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_INFO_PREFIX:PATH=/usr -S . -B ./build
		cmake --build ./build --config Release --target all -j$(nproc 2>/dev/null || getconf NPROCESSORS_CONF)
		sudo cmake --install build
	fi
	cd ..
fi

echo "[INFO] Hyprland: hyprutils updated successfully"

# hyprgraphics
if [ -d hyprgraphics ]; then
	cd hyprgraphics/
	git pull &>"$tmp"
	if ! grep -q "Already up to date." "$tmp"; then
		cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_INFO_PREFIX:PATH=/usr -S . -B ./build
		cmake --build ./build --config Release --target all -j`nproc 2>/dev/null || getconf NPROCESSORS_CONF`
		sudo cmake --install build
	fi
	cd ..
fi

echo "[INFO] Hyprland: hyprgraphics updated successfully"

# seatd
if [ -d seatd ]; then
	cd seatd
	git pull &>"$tmp"
	if ! grep -q "Already up to date." "$tmp"; then
		meson setup build
		ninja -C build
		sudo ninja -C build install
	fi
	cd ..
fi

echo "[INFO] Hyprland: seatd updated successfully"

# hyprwayland-scanner
if [ -d hyprwayland-scanner ]; then
	cd hyprwayland-scanner
	git pull &>"$tmp"
	if ! grep -q "Already up to date." "$tmp"; then
		cmake -DCMAKE_INFO_PREFIX=/usr -B build
		cmake --build build -j `nproc`
		sudo cmake --install build
	fi
	cd ..
fi

echo "[INFO] Hyprland: hyprwayland-scanner updated successfully"

# aquamarine
if [ -d aquamarine ]; then
	cd aquamarine
	git checkout -f
	git pull &>"$tmp"
	if !  grep -q "Already up to date." "$tmp"; then
		tmp=$(mktemp)
		while IFS= read -r line; do
			if echo "$line" | grep -q "target_link_libraries(aquamarine OpenGL::EGL OpenGL::OpenGL PkgConfig::deps)"; then
				echo "target_link_libraries(aquamarine PRIVATE GLESv2 EGL PkgConfig::deps)" >> "$tmp"
			elif ! echo "$line" | grep -q "find_package(OpenGL REQUIRED COMPONENTS"; then
				echo "$line" >> "$tmp"
			fi
		done < CMakeLists.txt

		mv "$tmp" CMakeLists.txt
		cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_INFO_PREFIX:PATH=/usr -S . -B ./build
		cmake --build ./build --config Release --target all -j`nproc 2>/dev/null || getconf _NPROCESSORS_CONF`
		sudo cmake --install build
	fi
	cd ..
fi

echo "[INFO] Hyprland: aquamarine updated successfully"

# hyprlang
if [ -d hyprlang ]; then
	cd hyprlang
	git pull &>"$tmp"
	if ! grep -q "Already up to date." "$tmp"; then
		cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_INFO_PREFIX:PATH=/usr -S . -B ./build
		cmake --build ./build --config Release --target hyprlang -j`nproc 2>/dev/null || getconf _NPROCESSORS_CONF`
		sudo cmake --install ./build
	fi
	cd ..
fi

echo "[INFO] Hyprland: hyprlang updated successfully"

# hyprtoolkit
if [ -d hyprtoolkit ]; then
	cd hyprtoolkit
	git checkout -f
	git pull &>"$tmp"
	if ! grep -q "Already up to date." "$tmp"; then
		tmp=$(mktemp)
		b=false
		while IFS= read -r line; do
			if echo "$line" | grep -q "target_link_libraries(hyprtoolkit PUBLIC OpenGL::EGL OpenGL::OpenGL"; then
				echo "target_link_libraries(hyprtoolkit PRIVATE GLESv2 EGL PkgConfig::deps)" >> "$tmp"
				b=true
				continue
			elif [ "$b" = true ]; then
				b=false
				continue
			else
				echo "$line" >> "$tmp"
			fi
		done < CMakeLists.txt
		mv "$tmp" CMakeLists.txt
		cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_INFO_PREFIX:PATH=/usr -S . -B ./build
		cmake --build ./build --config Release --target all -j`nproc 2>/dev/null || getconf NPROCESSORS_CONF`
		sudo cmake --install ./build
	fi
	cd ..
fi

echo "[INFO] Hyprland: hyprtoolkit updated successfully"

# hyprcursor
if [ -d hyprcursor ]; then
	cd hyprcursor
	git pull &>"$tmp"
	if ! grep -q "Already up to date." "$tmp"; then
		cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_INFO_PREFIX:PATH=/usr -S . -B ./build
		cmake --build ./build --config Release --target all -j`nproc 2>/dev/null || getconf _NPROCESSORS_CONF`
		sudo cmake --install build
	fi
	cd ..
fi

echo "[INFO] Hyprland: hyprcursor updated successfully"

# wayland-protocols
if [ -d wayland-protocols ]; then
	cd wayland-protocols
	git pull &>"$tmp"
	if ! grep -q "Already up to date." "$tmp"; then
		mkdir build
		cd build
		meson setup --prefix=/usr --buildtype=release ..
		ninja
		sudo ninja install
	fi
	cd ../..
fi

echo "[INFO] Hyprland: wayland-protocols updated successfully"

# libxkbcommon
if [ -d libxkbcommon ]; then
	cd libxkbcommon
	git pull &>"$tmp"
	if ! grep -q "Already up to date." "$tmp"; then
		meson setup build \
		      -Denable-x11=false \
		      -Dxkb-config-root=/usr/share/X11/xkb \
		      -Dx-locale-root=/usr/share/X11/locale
		meson compile -C build
		sudo meson install -C build
	fi
	cd ..
fi

echo "[INFO] Hyprland: libxkbcommon updated successfully"

# hyprwire
if [ -d hyprwire ]; then
	cd hyprwire
	git pull &>"$tmp"
	if ! grep -q "Already up to date." "$tmp"; then
		cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_INFO_PREFIX:PATH=/usr -S . -B ./build
		cmake --build ./build --config Release --target all -j`nproc 2>/dev/null || getconf NPROCESSORS_CONF`
		sudo cmake --install build
	fi
	cd ..
fi

echo "[INFO] Hyprland: hyprwire updated successfully"

# glaze
if [ -d glaze ]; then
	cd glaze
	git pull &>"$tmp"
	if ! grep -q "Already up to date." "$tmp"; then
		sudo systemctl start docker
		sudo docker pull ubuntu:24.04
		sudo docker run --rm \
		  --network host \
		  -v $(pwd):/src \
		  -w /src \
		  ubuntu:24.04 bash -c "
		    apt-get update && \
		    apt-get upgrade -y && \
		    apt-get install -y git cmake g++ ninja-build libasan8 openssl libssl-dev && \
		    mkdir -p build && cd build && \
		    cmake .. && \
		    make -j\$(nproc) && \
		    cmake --install . --prefix /src/install
		  "
		cp -r install/include/* /usr/local/include/
		cp -r install/share/* /usr/local/share/
	fi
	cd ..
fi

echo "[INFO] Hyprland: glaze updated successfully"

# Hyprland
if [ -d Hyprland ]; then
	cd Hyprland
	git pull &>"$tmp"
	if ! grep -q "Already up to date." "$tmp"; then
		make all
		sudo make install
	fi
	cd ..
fi

echo "[INFO] Hyprland: Hyprland updated successfully"



echo "Updating additional utils..."

# wvkbd
if [ -d wvkbd ]; then
	cd wvkbd
	git pull &>"$tmp"
	if ! grep "Already up to date." "$tmp"; then
		make
		sudo make install
	fi
	cd ..
fi

echo "[INFO] utilities: wvkbd updated successfully"

# sysmenu
if [ -d sysmenu ]; then
	cd sysmenu
	git pull &>"$tmp"
	if ! grep -q "Already up to date." "$tmp"; then
		make
		sudo make install
	fi
	cd ..
fi

echo "[INFO] utilities: sysmenu updated successfully"

# hyprshot
if [ -d Hyprshot ]; then
	cd Hyprshot
	git pull &>/dev/null
	cd ..
fi

echo "[INFO] utilities: hyprshot updated successfully"

echo "Hyprland is up to date!"
