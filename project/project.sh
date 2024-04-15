#!/bin/bash

#put functions here if you make any



echo "Welcome to the file backup utility"

while true; do
    echo "Please choose an option:"
    echo "1) Choose backup location"
    echo "2) Choose compression options"
    echo "3) Start backup"
    echo "4) Exit"
    read -r -p "Enter your choice: " choice

    case $choice in
        1)
            echo "Choose backup location (e.g., /backups/, anywhere not your home directory) (backup directory will be created in this path)"
            while true; do
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
            read -r -p "Compress files (y/N)? "
            case "$compress_choice" in
            [Yy]) compress_choice=1;;
            [Nn]) compress_choice=0;;
            esac
            echo "you chose $compress_choice"
            ;;
        3)

            mkdir "$backup_location/backup" #create target directory
            
            echo "Starting backup..."
            
            cp -r "/home/$USER" "/$backup_location/backup" #cp -r copies files recursively ie all files in a directory, files within those directories
            
            tar -cvzf backupCompressed "/$backup_location/backup" #tar stores files in an archive -v verbose, show output -z compress with gzip -f specifies file name


            
            
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
