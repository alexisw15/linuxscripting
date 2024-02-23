#!/bin/bash
lsmnts(){
    findmnt -D -t notmpfs, nodevtmpfs
}

echo "Welcome!"
echo ""
echo "_____ Kernel Name, Release, Version _____"
uname -a
echo ""
echo "_____ Memory usage stats: _____"
free -h
echo "_____ Disk usage stats: _____"
lsmnts