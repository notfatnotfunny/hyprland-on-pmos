lisgd -d /dev/input/by-path/platform-a90000.i2c-event -g '1,DU,B,*,*,kill -SIGRTMIN "$(pgrep wvkbd-mobintl)"' -g "1,UD,T,*,*,hyprshot -m region" 
