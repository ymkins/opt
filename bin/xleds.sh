#!/usr/bin/env bash
#
# https://askubuntu.com/questions/850997/no-caps-lock-indicator-light/851093
# http://goodies.xfce.org/projects/panel-plugins/xfce4-genmon-plugin

off='⚪'
on='⚫'

caps=$off
num=$off
scroll=$off

led_str=$(xset -q)
caps_lock='Caps Lock:   on'
num_lock='Num Lock:    on'
scroll_lock='Scroll Lock: on'
[ -z "${led_str##*$caps_lock*}" ] && caps=$on
[ -z "${led_str##*$num_lock*}" ] && num=$on
[ -z "${led_str##*$scroll_lock*}" ] && scroll=$on

echo  ${caps}${num}${scroll}
