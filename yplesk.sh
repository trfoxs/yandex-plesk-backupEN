#!/bin/bash
##
# Name: Plesk Yandex weekly update
# Author: trfoxs
# Update: trfoxs
# Version: 1.0.1
# Description: Yandex sync plesk backup

if [ $(which yandex-disk) ]; then
clear
echo -e "
.########.########..########..#######..##.....##..######.
....##....##.....##.##.......##.....##..##...##..##....##
....##....##.....##.##.......##.....##...##.##...##......
....##....########..######...##.....##....###.....######.
....##....##...##...##.......##.....##...##.##.........##
....##....##....##..##.......##.....##..##...##..##....##
....##....##.....##.##........#######..##.....##..######.

[TR] Yandex Disk Plesk Backup
................................................
"
	echo -e "[\e[31mOK\e[39m] Yandex-disk detected !"
	echo -e "[\e[93mDOING\e[39m] Please specify yandex directory, e.g: /var/home/plesk-backup: "
	read -p "Dizin Adı: " foldername
	echo -e "[\e[93mDOING\e[39m] Checking the directory, $foldername..."
	
	# folder check
	if [ -d "$foldername" ]; then 
		echo -e "[\e[31mOK\e[39m] $foldername already exists"
	
		# create plesk cron.weekly
		if [ $(which plesk) ]; then 
			echo -e "[\e[31mOK\e[39m] Plesk detected !"
			echo -e "[\e[93mDOING\e[39m] Generating Plesk auto backup cron.weekly..."
			rm -f /etc/cron.weekly/plesk-yandex-backup
			touch /etc/cron.weekly/plesk-yandex-backup

echo "\
#!/bin/bash
##
# Name: Plesk Yandex weekly update
# Author: trfoxs
# Update: trfoxs
# Version: 1.0.1
# Description: Yandex sync plesk backup

SYNC_DIR=$foldername/plesk-backup
DATE="'`date +%Y-%m-%d-%H%i%s`'"

if [ "'$(which yandex-disk)'" ]; then 
[ -d "'$SYNC_DIR'" ] || mkdir "'$SYNC_DIR'"
/usr/local/psa/bin/pleskbackup server --incremental --description=\"Server incremental backup\" --output-file=\""'$SYNC_DIR'"/server-incremental-backup-"'$DATE'".tar\"
yandex-disk sync
exit 0
else
exit 1
fi"\ > /etc/cron.weekly/plesk-yandex-backup

			chmod +x /etc/cron.weekly/plesk-yandex-backup
			
			sleep 5
			echo -e "[\e[31mOK\e[39m] Plesk auto backup cron.weekly creation successful."
			echo -e "\n enjoy :) "
			
		else 
			echo -e "[\e[31mFAIL\e[39m] Plesk is not installed, try again."
			echo -e "[\e[31mOK\e[39m] The program is closing :(."
			exit 1
		fi
		
	else
		echo -e "[\e[31mFAIL\e[39m] Please make sure the directory exists and try again."
		echo -e "[\e[31mOK\e[39m] The program is closing :(."
		exit 1
	fi

fi