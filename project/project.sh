#!/bin/bash

#put functions here if you make any



echo "Welcome to the file backup utility"

while true; do
    echo "Please choose an option:"
    echo "1) Choose backup location (Where it's going)"
    echo "2) choose backup path (Where it's coming from)" #could be phrased better
    echo "3) Start backup"
    echo "4) Exit"
    read -r -p "Enter your choice: " choice

    case $choice in
        1)
            echo "Choose backup location (e.g., /backups/, anywhere not your home directory) (backup directory will be created in this path)"
            while true; do #creates a loop, so if the user enters a bad path they get to try again, and the bad path isn't stored
                read -r -p "Enter path: " backup_location #reads user input, in this case a path to a directory
                # Validate user input
                if [[ -d "$backup_location" ]]; then #checks if location entered by user is a valid directory
                    echo "Backup location set to: $backup_location" #uses location variable to confirm to the user the location they entered
                    break
                else
                    echo "Error: Invalid directory. Please choose a valid path."
                fi
            done
            ;;
        2) 
            echo "choose path/directory that you want to be backed up: e.g. /home/yourname/Downloads"
            while true; do
                read -r -p "Enter path: " backup_path
                if [[ -d "$backup_path" ]]; then
                    echo "Path chosen to back up: $backup_path"
                    break
                else
                    echo "Error: not a directory, choose a valid directory"
                fi
            done
            #this code is really similar to the first part, since all we're doing is storing two paths
            ;;
        3)

            mkdir "$backup_location/backup" #create target directory
            
            echo "Starting backup..."
            
            #cp -r "/home/$USER/Downloads" "/$backup_location/backup" #cp -r copies files recursively ie all files in a directory, files within those directories
            
            tar -czvf "$backup_location/backup-$(date +%F).tar.gz" "$backup_path"

            sleep 5
            
            
            echo "Backup completed."
            ;;
        4)
            echo "Goodbye"
            exit 0
            ;;
        *)
            echo "Invalid option. Please choose 1-4."
            ;;
    esac
done
