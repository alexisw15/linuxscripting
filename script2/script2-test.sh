#!/bin/bash
# Define functions
kernel_info() { #lists kernel info
    echo "test kernel information"
    uname -a #uname prints information about kernel and OS -a means print all information
    sleep 5 #waits 5 seconds
    exec $0 #restarts script (back to main menu)
}
memory_info() { #lists free memory
    echo "test memory info"
    free -h #free displays total free/used memory -h means "human" format (shortest three digit number)
    sleep 5
    exec $0
}
storage_info() { #this lists all disks (looks weird on WSL due to lots of file systems, looks normal on regular linux distros)
    echo "test storage info"
    findmnt -D   #findmnt lists file systems -D option imitates the output of df, meaning that you get nice looking columns with the information we need
    sleep 5
    exec $0
}
process_info() {                    #this lists the top 5 processes
    echo "test processes"
    ps aux --sort -rss | head -n 5 #a = processes for all users u= show process owner x= show processes not attached to a terminal 
                                    # -rss resident set size, how much memory a process has used in kb
                                    # pipe to head -n 5 displays only the top 5 results, cuts off the rest of the result.
    sleep 5
    exec $0
}

connection_test() { #this pings google.com then prints either success or fail based on if the command succeeds or not
    echo "Connection test:"
    #ping google.com once, send output to shadow realm (/dev/null)
    if ! ping -c 1 google.com &>/dev/null; then
        echo "Connection failed!"
        # Print failed only if the connection fails 
    else
        echo "Connection successful!" #print success only if ping successful
    sleep 5
    exec $0
    fi
}
network_info(){
    echo "Network Information:" #this prints out just the required information (hostname, ip, and uptime)
    hostname #displays hostname
    hostname -I #-I displays IP address
    uptime -p #shows uptime, -p for "pretty" format
    sleep 5
    exec $0

}
service_stuff() {
    #stuff this needs to do: can modify service (stop, start, restart)
    #
    echo "Services: (may need sudo)"
    systemctl list-units --type=service --all --no-pager #list units - displays everything that systemd has loaded in memory 
                                                        #--type=service - filters the result to only services
                                                        # --all -shows all seervices, even stopped/inactive ones
                                                        # -- no-pager - does not use a pager (ie, display all results at once, not in pages)
    echo "enter the name of the service you would like to change" #they have to type a service name
    read servicename #stores what they typed in servicename
    echo "you chose $servicename" 
    
    echo "what would you like to do:" 
    echo "1. stop a service" 
    echo "2. start a service" 
    echo "3. restart a service"
    
    read n
    case $n in
    1) echo "stopping service $servicename ...."
        systemctl stop $servicename #stops the given service
        sleep 5
    ;;
    2) echo "starting service $servicename ...."
        systemctl start $servicename #starts the given service
        sleep 5
    ;;
    3) echo "restarting service $servicename"
        systemctl restart $servicename #restarts the service
        sleep 5
    ;;
    *) echo "invalid option"
        sleep 5
    ;;
    esac
    
    #execute the chosen action on the chosen service



    sleep 5
    exec $0
}
exit_button() {
    echo "test exit button"
    exit
}

#friendly message :)
echo "Welcome!"
echo "It is currently:" 
#displays current time (in iso standard)
date --iso-8601=seconds
# Source: https://unix.stackexchange.com/questions/146570/arrow-key-enter-menu
# for wait 5 seconds use command 'sleep 5'
# Renders a text based list of options that can be selected by the
# user using up, down and enter keys and returns the chosen option.
#
#   Arguments   : list of options, maximum of 256
#                 "opt1" "opt2" ...
#   Return value: selected index (0 for opt1, 1 for opt2 ...)
function select_option {
    # this section controls the arrow key input
    # little helpers for terminal print control and key input
    ESC=$( printf "\033")
    cursor_blink_on()  { printf "$ESC[?25h"; }
    cursor_blink_off() { printf "$ESC[?25l"; }
    cursor_to()        { printf "$ESC[$1;${2:-1}H"; }
    print_option()     { printf "   $1 "; }
    print_selected()   { printf "  $ESC[7m $1 $ESC[27m"; }
    get_cursor_row()   { IFS=';' read -sdR -p $'\E[6n' ROW COL; echo ${ROW#*[}; }
    key_input()        { read -s -n3 key 2>/dev/null >&2
                         if [[ $key = $ESC[A ]]; then echo up;    fi
                         if [[ $key = $ESC[B ]]; then echo down;  fi
                         if [[ $key = ""     ]]; then echo enter; fi; }

    # initially print empty new lines (scroll down if at bottom of screen)
    for opt; do printf "\n"; done

    # determine current screen position for overwriting the options
    local lastrow=`get_cursor_row`
    local startrow=$(($lastrow - $#))

    # ensure cursor and input echoing back on upon a ctrl+c during read -s
    trap "cursor_blink_on; stty echo; printf '\n'; exit" 2
    cursor_blink_off

    local selected=0
    while true; do
        # print options by overwriting the last lines
        local idx=0
        for opt; do
            cursor_to $(($startrow + $idx))
            if [ $idx -eq $selected ]; then
                print_selected "$opt"
            else
                print_option "$opt"
            fi
            ((idx++))
        done

        # user key control
        case `key_input` in
            enter) break;;
            up)    ((selected--));
                   if [ $selected -lt 0 ]; then selected=$(($# - 1)); fi;;
            down)  ((selected++));
                   if [ $selected -ge $# ]; then selected=0; fi;;
        esac
    done

    # cursor position back to normal
    cursor_to $lastrow
    printf "\n"
    cursor_blink_on

    return $selected
}

echo "Select an option using up/down arrow keys and enter to confirm:"
echo

options=("Kernel Info" "Memory Usage" "Storage Usage" "Active Processes" "Connection Test" "Services (may need sudo)" "Network Info" "Exit")

select_option "${options[@]}"
choice=$?

#echo "Chosen index = $choice"
#echo "        value = ${options[$choice]}"

# Call the appropriate function based on the user's choice
case $choice in
    0) kernel_info ;;
    1) memory_info ;;
    2) storage_info ;;
    3) process_info ;;
    4) connection_test ;;
    5) service_stuff ;; 
    6) network_info;;
    7) exit_button ;;
esac

