

sudo apk update
sudo apk upgrade

# hyprutils
cd hyprutils/
git pull
cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_INSTALL_PREFIX:PATH=/usr -S . -B ./build
cmake --build ./build --config Release --target all -j`nproc 2>/dev/null || getconf NPROCESSORS_CONF`
sudo cmake --install build
cd ..

# hyprgraphics
cd hyprgraphics/
git pull
cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_INSTALL_PREFIX:PATH=/usr -S . -B ./build
cmake --build ./build --config Release --target all -j`nproc 2>/dev/null || getconf NPROCESSORS_CONF`
sudo cmake --install build
cd ..


cd hyprwayland-scanner
git pull
cmake -DCMAKE_INSTALL_PREFIX=/usr -B build
cmake --build build -j `nproc`
sudo cmake --install build
cd ..

cd aquamarine
git pull
cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_INSTALL_PREFIX:PATH=/usr -S . -B ./build
cmake --build ./build --config Release --target all -j`nproc 2>/dev/null || getconf _NPROCESSORS_CONF`
sudo cmake --install build
cd ..

cd hyprlang
git pull
cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_INSTALL_PREFIX:PATH=/usr -S . -B ./build
cmake --build ./build --config Release --target hyprlang -j`nproc 2>/dev/null || getconf _NPROCESSORS_CONF`
sudo cmake --install ./build
cd ..


cd hyprcursor
git pull
cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_INSTALL_PREFIX:PATH=/usr -S . -B ./build
cmake --build ./build --config Release --target all -j`nproc 2>/dev/null || getconf _NPROCESSORS_CONF`
sudo cmake --install build
cd ..


cd wayland-protocols
git pull
sudo rm -rf build
mkdir build
cd build
meson setup --prefix=/usr --buildtype=release ..
ninja
sudo ninja install
cd ../..


cd libxkbcommon
git pull
meson setup build \
      -Denable-x11=false \
      -Dxkb-config-root=/usr/share/X11/xkb \
      -Dx-locale-root=/usr/share/X11/locale
meson compile -C build
sudo meson install -C build
cd ..


#hyprwire
cd hyprwire
git pull
cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_INSTALL_PREFIX:PATH=/usr -S . -B ./build
cmake --build ./build --config Release --target all -j`nproc 2>/dev/null || getconf NPROCESSORS_CONF`
sudo cmake --install build
cd ..


# Hyprland
cd Hyprland
git pull
make all
sudo make install


# to build

# wvkbd
cd wvkbd
git pull
make
sudo make install
cd ..


# sysmenu
cd sysmenu
git pull
make
sudo make install
cd ..

# hyprgrass plugin
hyprpm update --no-shallow
hyprpm reload
