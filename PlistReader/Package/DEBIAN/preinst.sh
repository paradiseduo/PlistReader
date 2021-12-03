#!/bin/sh

#  preinst.sh
#  PlistReader
#
#  Created by Paradiseduo on 2021/12/1.
#  

echo "Remove old files"
rm -rf /Applications/PlistReader.app > /dev/null
