#!/bin/bash -xe

path=`dirname $0`

echo $path

BUILDTYPE=SRPM "${path}/../fedora/rpm/build.sh"
sudo zypper install `rpm -qR -p /home/pavlix/src/suse/src/NetworkManager/contrib/fedora/rpm/latest/SRPMS/NetworkManager-*.src.rpm`
