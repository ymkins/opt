#!/usr/bin/env bash
#
# inspired by
#   https://askubuntu.com/questions/850997/no-caps-lock-indicator-light/851093
#   http://goodies.xfce.org/projects/panel-plugins/xfce4-genmon-plugin
#
# by default produce one of (cns Cns cNs CNs cnS CnS cNS CNS)
# but can return one of positional parameters
# for example, try lights: ⚪ ⚫ ✾ ✧ ✺ ✼ ✽
# $ xleds '✧✧✧' '✺✧✧' '✧✺✧' '✺✺✧' '✧✧✺' '✺✧✺' '✧✺✺' '✺✺✺'
#
# fix XKB indicators delay in case of immedentialy call
#  sleep 0.2

xset=$(xset q)
caps_lock='Caps Lock:   on'
num_lock='Num Lock:    on'
scroll_lock='Scroll Lock: on'
leds=0
[ -z "${xset##*$caps_lock*}" ] && (( leds=leds+1 ))
[ -z "${xset##*$num_lock*}" ] && (( leds=leds+2 ))
[ -z "${xset##*$scroll_lock*}" ] && (( leds=leds+4 ))

format=('cns' 'Cns' 'cNs' 'CNs' 'cnS' 'CnS' 'cNS' 'CNS')
[ $8 ] && format=("$@")
echo  ${format[$leds]}

# cat <<EOF
# <txt>${format[$leds]}</txt>
# <tool>
# ${xset}
# </tool>
# EOF
