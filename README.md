# hyprland-on-pmos
Build Hyprland on PostmarketOs from git source. The packaged version in pmos is old and doesn't support some of the new features shipped with more recent versions.


## Installation

~~First of all your pmOS device *must* use openrc as a service manager (systemd conflicts with some libraries eg. libinput).~~

Dependecies:

`doas apk add git cmake meson pixman-dev cairo-dev pango-dev libjpeg-turbo-dev libwebp-dev librsvg-dev file-dev udis86-git-dev mesa-egl mesa-gles mesa-dev pugixml-dev libseat-dev libinput-dev wayland-dev wayland-protocols-dev libdisplay-info-dev hwdata-dev libzip-dev tomlplusplus-dev bison libxcursor-dev re2-dev muparser-dev xcb-util-wm-dev xcb-util-errors-dev cpio libxcomposite-dev xcb-util-keysyms xcb-util-keysyms-dev libliftoff cpio hyprland-protocols hyprland-qtutils`

   `doas ./hyprinstaller.sh`
      
To update run
   
   `doas ./hyprupdater.sh`
