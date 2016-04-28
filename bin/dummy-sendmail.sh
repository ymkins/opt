#!/bin/sh
# https://habrahabr.ru/post/49665/

prefix="/var/mail/dummy-sendmail"
date=`date \+\%Y\%m\%d\%H\%M\%N`

name="$prefix/$date.eml"
while read line
do
echo $line >> $name
done
chmod 666 $name
