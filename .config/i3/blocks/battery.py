#!/usr/bin/env python3
#
# Copyright (C) 2016 James Murphy
# Licensed under the GPL version 2 only
# Modified by Siem Hermans
#
# A battery indicator blocklet script for i3blocks

from subprocess import check_output

status = check_output(['acpi'], universal_newlines=True)

if not status:
    # stands for no battery found
    fulltext = "<span color='red'><span font='FontAwesome'>\uf244 " " \uf00d</span></span>"
    percentleft = 100
else:
    state = status.split(": ")[1].split(", ")[0]
    commasplitstatus = status.split(", ")
    percentleft = int(commasplitstatus[1].rstrip("%\n"))

    time = commasplitstatus[-1].split()[0]
    time = ":".join(time.split(":")[0:2])

    # stands for plugged in
    FA_PLUG = "<span font='FontAwesome'>\uf1e6</span>"
    FA_BATTERY = "<span font='FontAwesome'>\uf240</span>"

    fulltext = ""
    timeleft = ""

    if state == "Discharging":
        if 51 <= percentleft <= 75:
            FA_BATTERY = "<span font='FontAwesome'>\uf241</span>"
        elif 26 <= percentleft <= 50:
            FA_BATTERY = "<span font='FontAwesome'>\uf242</span>"
        elif 11 <= percentleft <= 25:
            FA_BATTERY = "<span font='FontAwesome'>\uf243</span>"
        elif 0 <= percentleft <= 10:
            FA_BATTERY = "<span font='FontAwesome'>\uf244</span>"
        else:
            FA_BATTERY = "<span font='FontAwesome'>\uf240</span>"
        fulltext = FA_BATTERY + " "
        timeleft = " ({})".format(time)
    elif state == "Full":
        fulltext = FA_PLUG + " "
    elif state == "Unknown":
        fulltext = "<span font='FontAwesome'>\uf128</span> "
    else:
        fulltext = FA_PLUG + " "
        timeleft = " ({})".format(time)

    def color(percent):
        if state == "Discharging":
            if percent < 10:
                # exit code 33 will turn background red
                return "#FFFFFF"
            if percent < 25:
                return "#FF5555"
            if percent < 50:
                return "#FF7A3E"
            if percent < 75:
                return "#EDE84B"
            else:
                return "#50FA7B"
        else:
            return "#FFFFFF"

    form = '<span color="{}">{}%</span>'
    fulltext += form.format(color(percentleft), percentleft)
    fulltext += timeleft

print(fulltext)
#print(fulltext)
if percentleft < 10 and state =="Discharging":
    exit(33)
