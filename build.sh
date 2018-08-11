#!/bin/bash

VERSION=1.2.1

sayAndDo () {
	echo $@
	eval $@
	if [ $? -ne 0 ]
	then
		echo "ERROR: command failed!"
		exit 1
	fi
}

installIfMissing () {
	dpkg -s $@ > /dev/null
	if [ $? -ne 0 ]; then
		echo " - oops, missing $@, installing"
		apt-get install $@
	else
		echo " - $@ ok"
	fi
	echo
}

if [ -d coredumper-$VERSION ]
then
	sayAndDo rm -rf coredumper-$VERSION
	git clone https://github.com/lealarcon/coredumper-1.2.1
fi




sayAndDo cd coredumper-$VERSION
sayAndDo mv packages/deb debian
sayAndDo chmod 644 debian/control
sayAndDo patch -p0 < ../fix_from_scratch_build.patch
sayAndDo dpkg-buildpackage -us -uc

