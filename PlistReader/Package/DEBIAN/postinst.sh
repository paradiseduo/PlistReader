#!/bin/sh

#  postinst.sh
#  PlistReader
#
#  Created by Paradiseduo on 2021/12/1.
#  

#!/bin/bash

echo "Set permission..."

chown -R root:wheel /Applications/PlistReader.app/PlistReader
chmod 0775 /Applications/PlistReader.app/PlistReader


#echo "Clean icon cache..."
#su -c /usr/bin/uicache mobile > /dev/null


#The RESPRING script after Install
declare -a cydia
cydia=($CYDIA)

if [[ $1 == install || $1 == upgrade ]]; then
    if [[ ${CYDIA+@} ]]; then
        eval "echo 'finish:reload' >&${cydia[0]}"
    fi
fi

exit 0

