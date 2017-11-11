#!/bin/bash

scrot /tmp/screen.png
convert /tmp/screen.png -scale 10% -scale 1000% /tmp/screen.png

if [[ -f $XDG_DATA_HOME/assets/screen-lock.png ]]
then
    # placement x/y
    PX=0
    PY=0
    # lockscreen image info
    R=$(file $XDG_DATA_HOME/assets/screen-lock.png | grep -o '[0-9]* x [0-9]*')
    RX=$(echo $R | cut -d' ' -f 1)
    RY=$(echo $R | cut -d' ' -f 3)

    SR=$(xrandr --query | grep ' connected' | sed -e "s/primary //g" | cut -f3 -d' ')
    for RES in $SR
    do
        # monitor position/offset
        SRX=$(echo $RES | cut -d'x' -f 1)                   # x pos
        SRY=$(echo $RES | cut -d'x' -f 2 | cut -d'+' -f 1)  # y pos
        SROX=$(echo $RES | cut -d'x' -f 2 | cut -d'+' -f 2) # x offset
        SROY=$(echo $RES | cut -d'x' -f 2 | cut -d'+' -f 3) # y offset
        PX=$(($SROX + $SRX/2 - $RX/2))
        PY=$(($SROY + $SRY/2 - $RY/2))

        convert /tmp/screen.png $XDG_DATA_HOME/assets/screen-lock.png -geometry +$PX+$PY -composite -matte  /tmp/screen.png
        echo "done"
    done
fi

amixer -q -D pulse sset Master mute # mute audio
killall -SIGUSR1 dunst # pause noficiations

# lock the session
i3lock -e -u -f -n -i /tmp/screen.png

killall -SIGUSR2 dunst # resume notifications
setxkbmap -option caps:swapescape
#amixer -q -D pulse sset Master toggle # resume audio
