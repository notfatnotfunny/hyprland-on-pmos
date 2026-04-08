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
if ! pkg-config --exists hyprutils; then
	cd hyprutils/
	cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_INFO_PREFIX:PATH=/usr -S . -B ./build
	cmake --build ./build --config Release --target all -j`nproc 2>/dev/null || getconf NPROCESSORS_CONF`
	sudo cmake --install build
	cd ..
fi

echo "[INFO] Hyprland: hyprutils installed successfully"

# hyprgraphics
if [ ! -d hyprgraphics ]; then
	git clone https://github.com/hyprwm/hyprgraphics &>/dev/null
fi
if ! pkg-config --exists hyprgraphics; then
	cd hyprgraphics/
	cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_INFO_PREFIX:PATH=/usr -S . -B ./build
	cmake --build ./build --config Release --target all -j`nproc 2>/dev/null || getconf NPROCESSORS_CONF`
	sudo cmake --install build
	cd ..
fi

echo "[INFO] Hyprland: hyprgraphics installed successfully"

# seatd
if [ ! -d seatd ]; then
	git clone https://git.sr.ht/~kennylevinsen/seatd &>/dev/null
fi
if [ ! -f /usr/local/bin/seatd ]; then
	cd seatd
	meson setup build
	ninja -C build
	sudo ninja -C build install
	cd ..
fi

echo "[INFO] Hyprland: seatd installed successfully"

# hyprwayland-scanner
if [ ! -d hyprwayland-scanner ]; then
	git clone https://github.com/hyprwm/hyprwayland-scanner.git &>/dev/null 
fi
if ! pkg-config --exists hyprwayland-scanner; then
	cd hyprwayland-scanner
	cmake -DCMAKE_INFO_PREFIX=/usr -B build
	cmake --build build -j `nproc`
	sudo cmake --install build
	cd ..
fi

echo "[INFO] Hyprland: hyprwayland-scanner installed successfully"

# aquamarine
if [ ! -d aquamarine ]; then
	git clone https://github.com/hyprwm/aquamarine.git &>/dev/null 
fi
if ! pkg-config --exists aquamarine; then
	cd aquamarine
	# remove the line 
	#   find_package(OpenGL REQUIRED COMPONENTS "GLES3")  
	# and change the line
	#   target_link_libraries(aquamarine OpenGL::EGL OpenGL::OpenGL PkgConfig::deps)
	#   to
	#   target_link_libraries(aquamarine PRIVATE GLESv2 EGL PkgConfig::deps)
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
	cd ..
fi

echo "[INFO] Hyprland: aquamarine installed successfully"

# hyprlang
if [ ! -d hyprlang ]; then
	git clone https://github.com/hyprwm/hyprlang.git &>/dev/null 
fi
if ! pkg-config --exists hyprlang; then
	cd hyprlang
	cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_INFO_PREFIX:PATH=/usr -S . -B ./build
	cmake --build ./build --config Release --target hyprlang -j`nproc 2>/dev/null || getconf _NPROCESSORS_CONF`
	sudo cmake --install ./build
	cd ..
fi

echo "[INFO] Hyprland: hyprlang installed successfully"

# hyprtoolkit
if [ ! -d hyprtoolkit ]; then
	git clone https://github.com/hyprwm/hyprtoolkit.git &>/dev/null
fi
if ! pkg-config --exists hyprtoolkit; then
	cd hyprtoolkit
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
	cd ..
fi

echo "[INFO] Hyprland: hyprtoolkit installed successfully"

# hyprcursor
if [ ! -d hyprcursor ]; then
	git clone https://github.com/hyprwm/hyprcursor.git &>/dev/null
fi
if ! pkg-config --exists hyprcursor; then
	cd hyprcursor
	cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_INFO_PREFIX:PATH=/usr -S . -B ./build
	cmake --build ./build --config Release --target all -j`nproc 2>/dev/null || getconf _NPROCESSORS_CONF`
	sudo cmake --install build
	cd ..
fi

echo "[INFO] Hyprland: hyprcursor installed successfully"

# wayland-protocols
if [ ! -d wayland-protocols ]; then
	git clone https://gitlab.freedesktop.org/wayland/wayland-protocols.git &>/dev/null 
fi
if ! pkg-config --exists wayland-protocols; then
	cd wayland-protocols
	mkdir build
	cd build
	meson setup --prefix=/usr --buildtype=release ..
	ninja
	sudo ninja install
	cd ../..
fi

echo "[INFO] Hyprland: wayland-protocols installed successfully"

# libxkbcommon
if [ ! -d libxkbcommon ]; then
	git clone https://github.com/xkbcommon/libxkbcommon.git &>/dev/null 
fi
if [ ! -f /usr/local/lib/libxkbcommon.so ]; then
	cd libxkbcommon
	meson setup build \
	      -Denable-x11=false \
	      -Dxkb-config-root=/usr/share/X11/xkb \
	      -Dx-locale-root=/usr/share/X11/locale
	meson compile -C build
	sudo meson install -C build
	cd ..
fi

echo "[INFO] Hyprland: libxkbcommon installed successfully"

# hyprwire
if [ ! -d hyprwire ]; then
	git clone https://github.com/hyprwm/hyprwire.git &>/dev/null 
fi
if ! pkg-config --exists hyprwire; then
	cd hyprwire
	cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_INFO_PREFIX:PATH=/usr -S . -B ./build
	cmake --build ./build --config Release --target all -j`nproc 2>/dev/null || getconf NPROCESSORS_CONF`
	sudo cmake --install build
	cd ..
fi

echo "[INFO] Hyprland: hyprwire installed successfully"

# glaze
if [ ! -d glaze ]; then
	git clone https://github.com/stephenberry/glaze.git &>/dev/null 
fi
if [ ! -f /usr/local/include/glaze/glaze.hpp ]; then
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
	    apt-get install -y git cmake g++ ninja-build libasan8 openssl libssl-dev && \
	    mkdir -p build && cd build && \
	    cmake .. && \
	    make -j\$(nproc) && \
	    cmake --install . --prefix /src/install
	  "
	cp -r install/include/* /usr/local/include/
	cp -r install/share/* /usr/local/share/
	cd ..
fi

echo "[INFO] Hyprland: glaze installed successfully"

# Hyprland
if [ ! -d Hyprland ]; then
	git clone https://github.com/hyprwm/Hyprland.git &>/dev/null 
fi
if [ ! -f /usr/local/bin/hyprland ]; then
	cd Hyprland
	make all
	sudo make install
	cd ..
fi

echo "[INFO] Hyprland: Hyprland installed successfully"





