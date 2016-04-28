#!/bin/bash

# http://www.opennet.ru/docs/RUS/bash_scripting_guide/bash_scripting_guide-prog.html.gz#x4462_html
# http://stackoverflow.com/questions/7676045/how-to-use-read-command-in-bash

# wmcells schema
# schema: q11 | w23 | w45 | ..

#debug=false|true
debug=true
$debug && echo -n '_debug_ ' && date --rfc-3339=seconds

schema=${1:-'q00'} #1st param default q00
case $schema in
  [qw][1-6][1-6])  ;;
  *)
    read -d '' msg <<'EOM'

(q)uartet          (w)ide
+-------+-------+  +-----+-----+-----+
|       |       |  |     |     |     |
|   1   |   3   |  |  1  |  3  |  5  |
|       |       |  |     |     |     |
+-------+-------+  +-----+-----+-----+
|       |       |  |     |     |     |
|   2   |   4   |  |  2  |  4  |  6  |
|       |       |  |     |     |     |
+-------+-------+  +-----+-----+-----+

EOM
    export msg
    export tmpfile='/var/tmp/wmcells.tmp'

    xterm -geometry 38x12 -title 'wmcells' -e 'echo "$msg"; \
      read -t5 -n3 -p"Enter schema [q11]: "; echo $REPLY > $tmpfile'
    read schema <<< `cat $tmpfile`
    rm $tmpfile
  ;;
esac

case $schema in
  [qwйц][1-6][1-6])  ;;
  *)  schema='q11'  ;;
esac

cells=${schema:1:2}
rows=2
cols=2
case ${schema:0:1} in
  [wц])  cols=3  ;;
esac
$debug && echo "schema: $schema; rows: $rows; cols: $cols; cells: $cells"

read wa_x wa_y wa_w wa_h <<< \
    `xprop -root |grep '_NET_WORKAREA.*=' |cut -d'=' -f2 |cut -d',' -f1,2,3,4 --output-delimiter=' '`
$debug && echo "workarea: ${wa_x}:${wa_y} ${wa_w}x${wa_h}"

wnd_id=`xprop -root |grep '_NET_ACTIVE_WINDOW(WINDOW)' |cut -d'#' -f2 |cut -d',' -f1`
read fr_l fr_r fr_t fr_b <<< \
    `xprop -id ${wnd_id} |grep '_NET_FRAME_EXTENTS.*=' |cut -d'=' -f2 |cut -d',' -f1,2,3,4 --output-delimiter=' '`
$debug && echo "frame: $fr_l $fr_r $fr_t $fr_b"

let cell_h=$wa_h/$rows
let cell_w=$wa_w/$cols
$debug && echo "cell: ${cell_w}x${cell_h}"

c1='11,12,13,14,15,16,21,23,25,31,32,41,51,52,61'
c2='22,24,26,42,62'
c3='33,34,35,36,43,45,53,54,63'
c4='44,46,64'
c5='55,56,65'
c6='66'
h1='11,13,15,22,24,26,31,33,35,42,44,46,51,53,55,62,64,66'
w1='11,12,21,22,33,34,43,44,55,56,65,66'
h2='12,14,16,21,23,25,32,34,36,41,43,45,52,54,56,61,63,65'
w2='13,14,23,24,31,32,35,36,41,42,45,46,53,54,63,64'
w3='15,16,25,26,51,52,61,62'

# window height
if [[ 0 != `expr "$h1" : ".*${cells}"` ]]
then
    let wnd_h=$cell_h-$fr_t-$fr_b
elif [[ 0 != `expr "$h2" : ".*${cells}"` ]]
then
    let wnd_h=$cell_h*2-$fr_t-$fr_b
fi
# window width
if [[ 0 != `expr "$w1" : ".*${cells}"` ]]
then
    let wnd_w=$cell_w-$fr_l-$fr_r
elif [[ 0 != `expr "$w2" : ".*${cells}"` ]]
then
    let wnd_w=$cell_w*2-$fr_l-$fr_r
elif [[ 0 != `expr "$w3" : ".*${cells}"` ]]
then
    let wnd_w=$cell_w*3-$fr_l-$fr_r
fi
# window corner
if [[ 0 != `expr "$c1" : ".*${cells}"` ]]
then
    wnd_x=$wa_x
    wnd_y=$wa_y
elif [[ 0 != `expr "$c2" : ".*${cells}"` ]]
then
    wnd_x=$wa_x
    let wnd_y=$wa_y+$cell_h
elif [[ 0 != `expr "$c3" : ".*${cells}"` ]]
then
    let wnd_x=$wa_x+$cell_w
    wnd_y=$wa_y
elif [[ 0 != `expr "$c4" : ".*${cells}"` ]]
then
    let wnd_x=$wa_x+$cell_w
    let wnd_y=$wa_y+$cell_h
elif [[ 0 != `expr "$c5" : ".*${cells}"` ]]
then
    let wnd_x=$wa_x+$cell_w*2
    wnd_y=$wa_y
elif [[ 0 != `expr "$c6" : ".*${cells}"` ]]
then
    let wnd_x=$wa_x+$cell_w*2
    let wnd_y=$wa_y+$cell_h
else
    $debug && echo "wrong parameter cells"
    exit 1
fi

$debug && echo "wnd: ${wnd_x}:${wnd_y} ${wnd_w}x${wnd_h}"

wmctrl -r :ACTIVE: -e "0,${wnd_x},${wnd_y},${wnd_w},${wnd_h}"

