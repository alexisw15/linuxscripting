#!/bin/bash
{
#friendly message :)
echo "Welcome!"
echo "It is currently:" 
#displays current time (in iso standard), useful for logging
date --iso-8601=seconds
echo "_____ Kernel Name, Release, Version _____"
#shows the kernel name, version, device name, kernel release, etc
uname -a
echo ""
echo "_____ Memory usage stats: _____"
#shows current memory usage in more readable units (GiB)
free -h
echo ""
echo "_____ Disk usage stats: _____"
#shows all mounted file systems with details like usage
findmnt -D
echo ""
echo "_____ Running processes info: _____ "
#displays top 5 processes sorted by memory usage
ps aux --sort -rss | head -n 5
#whole script including errors sent to file log.txt using tee
} 2>&1 | tee log.txt
