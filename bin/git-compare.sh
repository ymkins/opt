#!/bin/sh
# http://rackerhacker.com/2012/03/15/compare-commits-between-two-git-branches/

echo $1
echo $2


if [ $1=='' -o $2=='' ]; then
echo $0 usage: branch1 branch2
exit
fi

BRANCH1=`mktemp`
BRANCH2=`mktemp`

git log –pretty=format:'%H' $1 | sort > $BRANCH1
git log –pretty=format:'%H' $2 | sort > $BRANCH2

echo "**********************************************************************"
echo "Commits not in '$1′ branch."
echo "**********************************************************************"
for i in `diff $BRANCH1 $BRANCH2 | grep '^>' | sed -e 's/^> //'`
do
git –no-pager log -1 –oneline $i
done
echo

echo "**********************************************************************"
echo "Commits not in '$2′ branch."
echo "**********************************************************************"
for i in `diff $BRANCH1 $BRANCH2 | grep '^<' | sed -e 's/^< //'`
do
git –no-pager log -1 –oneline $i
done
echo

rm -f $BRANCH1 $BRANCH2
