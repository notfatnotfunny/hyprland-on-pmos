# hyprland-on-pmos
Utilities to build Hyprland (yes, https://hypr.land) on postmarketOS (you heard me, https://postmarketos.org).


## Usage

First of all your pmOS device *must* use openrc as a service manager (systemd conflicts with some libraries eg. libinput).
On a fresh installation of pmOS you can run

   `sudo ./hyprinstaller.sh`
      
To update run
   
   `sudo ./hyprupdater.sh`
      

