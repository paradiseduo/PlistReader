#!/bin/sh

#  postrm.sh
#  PlistReader
#
#  Created by Paradiseduo on 2021/12/1.
#  

#!/bin/bash

#echo "Clean icon cache..."
#su -c /usr/bin/uicache mobile > /dev/null

declare -a cydia
cydia=($CYDIA)

if [[ ${CYDIA+@} ]]; then
    eval "echo 'finish:reload' >&${cydia[0]}"
else
    echo "Please respring your device after this!"
fi

exit 0

