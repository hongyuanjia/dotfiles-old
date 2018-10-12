#!/bin/bash
systemctl --user stop aria2
list=`wget -qO- https://raw.githubusercontent.com/ngosang/trackerslist/master/trackers_all.txt|awk NF|sed ":a;N;s/\n/,/g;ta"`
if [ -z "`grep "bt-tracker" $HOME/.config/aria2/aria2.conf`" ]; then
    sed -i '$a bt-tracker='${list} $HOME/.config/aria2/aria2.conf
    echo add......
else
    sed -i "s@bt-tracker.*@bt-tracker=$list@g" $HOME/.config/aria2/aria2.conf
    echo update......
fi
systemctl --user start aria2
