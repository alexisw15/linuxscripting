#!/bin/bash
{
#generates unique log file name with time stamp
#generate_filename() {
#    date +"log_%Y%m%d_%H%M%S.txt"
#}

#this is supposed to filter to just "real" disks but doesnt work
lsmnts(){
    findmnt -D #-t notmpfs, nodevtmpfs
}

echo "Welcome!"
echo "It is currently:" 
date --iso-8601=seconds
echo "_____ Kernel Name, Release, Version _____"
uname -a
echo ""
echo "_____ Memory usage stats: _____"
free -h
echo ""
echo "_____ Disk usage stats: _____"
lsmnts
echo ""
echo "_____ Running processes info: _____ "
ps aux --sort -rss | head -n 5
} 2>&1 | tee log.txt