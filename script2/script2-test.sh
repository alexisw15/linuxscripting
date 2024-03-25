#!/bin/bash
# Define functions
kernel_info() {
    echo "test kernel information"
    uname -a
    sleep 5
    exec $0
}
memory_info() {
    echo "test memory info"
    free -h
    sleep 5
    exec $0
}
storage_info() {
    echo "test storage info"
    findmnt -D
    sleep 5
    exec $0
}
process_info() {
    echo "test processes"
    ps aux --sort -rss | head -n 5
    sleep 5
    exec $0
}

connection_test() {
    echo "test connection"
    
    while ! ping -c1 google.com &>/dev/null
            do echo "fail"
        done
        echo "success"

    sleep 5
    exec $0
}
network_info(){
    echo "networking test"
    hostname
    hostname -I
    uptime -p
    sleep 5
    exec $0

}
service_stuff() {
    #stuff this needs to do: can modify service (stop, start, restart)
    #
    echo "Services test"
    systemctl list-units --type=service --all --no-pager
    echo "type the name of the service you would like to modify:"
    read input
    echo "you entered" $input
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
#displays current time (in iso standard), useful for logging
date --iso-8601=seconds
# Source: https://unix.stackexchange.com/questions/146570/arrow-key-enter-menu
# i thought it was cool B)
# for wait 5 seconds use command 'sleep 5'

# Renders a text based list of options that can be selected by the
# user using up, down and enter keys and returns the chosen option.
#
#   Arguments   : list of options, maximum of 256
#                 "opt1" "opt2" ...
#   Return value: selected index (0 for opt1, 1 for opt2 ...)
function select_option {

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

echo "Select one option using up/down keys and enter to confirm:"
echo

options=("Kernel Info" "Memory Usage" "Storage Usage" "Active Processes" "Connection Test" "Services" "Network Info" "Exit")

select_option "${options[@]}"
choice=$?

echo "Chosen index = $choice"
echo "        value = ${options[$choice]}"

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

