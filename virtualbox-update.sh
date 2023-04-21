#!/bin/bash

set -e

URL=https://download.virtualbox.org/virtualbox

SUM=SHA256SUMS;

VERSION=`wget -qO - $URL/LATEST.TXT`

FILE=`wget -qO - $URL/$VERSION/$SUM | tee $SUM | grep amd64.run |  cut -d\* -f2`

EXTFILE="Oracle_VM_VirtualBox_Extension_Pack-$VERSION.vbox-extpack"
EXTURL="$URL/$VERSION/$EXTFILE"

[ -f $FILE ] || wget $URL/$VERSION/$FILE

[ -f $EXTFILE ] || wget $EXTURL

sha256sum -c --ignore-missing $SUM

chmod +x $FILE

sudo ./$FILE

mkdir tmp

cp $EXTFILE tmp.tar.gz

tar zxf tmp.tar.gz -C tmp/

LIC=`sha256sum tmp/ExtPack-license.txt | awk '{print $1}'`

rm -rf tmp*

sudo vboxmanage extpack install --replace --accept-license=$LIC $EXTFILE
