#!/bin/bash

### Update and Upgrade

	date | grep "Sat"
	if [[ "$?" == "0" ]]; then
	    sudo apt-get update
	    sudo DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" dist-upgrade
	else
	    sudo apt-get update
	    sudo DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" upgrade
	fi

### Update ClamAV

	freshclam
	clamscan -ri /srv/samba/ >> /var/log/clamav.log

### Git ~

	changeArrayHome=(
	            .mozilla
	            .config/autostart
	            nightly.sh
	            start_vnc.sh
	            .vnc
	            .vimrc
	            README.md
	            )

	for i in ${changeArrayHome[@]}; do
	    git status |grep "$i"
	    if [[ "$?" == "0" ]]; then
	    	clear
	        git --git-dir=/home/goit/.git --work-tree=/home/goit/ add $i
	        sleep 1
	    fi
	done

### Git ~/scripts

	clear
    echo "Copying scripts from /home/goit..."
    sleep 1
    cp /home/goit/*.sh /home/goit/scripts/bash/

	changeArrayScripts=(
	            bash/*
	            desktop/*
	            README.md
	            )

	for i in ${changeArrayScripts[@]}; do
	    git status |grep "$i"
	    if [[ "$?" == "0" ]]; then
	    	clear
	        git --git-dir=/home/goit/scripts/.git --work-tree=/home/goit/scripts add $i
	        sleep 1
	    fi
	done

### Push repos

	### Home
	clear
	echo "Pushing /home/goit/ to git..."
	git --git-dir=/home/goit/.git --work-tree=/home/goit/ commit -m "nightly commit"
	git --git-dir=/home/goit/.git --work-tree=/home/goit/ push origin master

	### Scripts
	clear
	echo "Pushing /home/goit/scripts to git..."
	git --git-dir=/home/goit/scripts/.git --work-tree=/home/goit/scripts commit -m "nightly commit"
	git --git-dir=/home/goit/scripts/.git --work-tree=/home/goit/scripts push origin master

# Test code
#git status |grep "Changes not staged for commit:"
#if [[ "$?" == "0" ]]; then
# git --git-dir=/home/goit/.git --work-tree=/home/goit/ commit -m "nightly commit"
# git --git-dir=/home/goit/.git --work-tree=/home/goit push origin master
#fi
