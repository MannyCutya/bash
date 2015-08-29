#!/bin/bash

# Update and Upgrade
date | grep "Sat"
if [[ "$?" == "0" ]]; then
    sudo apt-get update
    sudo DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" dist-upgrade
else
    sudo apt-get update
    sudo DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" upgrade
fi

# Update ClamAV
freshclam
clamscan -ri /srv/samba/ >> /var/log/clamav.log

# Git
changeArray=(
            .mozilla
            .config/autostart
            nightly.sh
            start_vnc.sh
            .vnc
            .vimrc
            README.md
            )

for i in ${changeArray[@]}; do
    git status |grep "$i"
    if [[ "$?" == "0" ]]; then
        git --git-dir=/home/goit/.git --work-tree=/home/goit/ add $i
    fi
done

#git status |grep "Changes not staged for commit:"
#if [[ "$?" == "0" ]]; then
git --git-dir=/home/goit/.git --work-tree=/home/goit/ commit -m "nightly commit"
git --git-dir=/home/goit/.git --work-tree=/home/goit push origin master
#fi
