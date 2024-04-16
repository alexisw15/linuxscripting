#!/bin/bash

#colours
GREEN='033[0;32m'
RED='033[0;31m'
BLUE='033[0;34m'
RESET='\033[0m'


echo "Welcome to the file backup utility"

while true; do
    echo "Please choose an option:"
    echo "1) Choose backup location (Where archive will be stored)"
    echo "2) choose backup path (What files are being backed up)" #could be phrased better
    echo "3) Start backup"
    echo "4) Restore from backup"
    echo "5) Exit"
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
                    echo "Error: not a directory, choose a valid directory"
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
            #this code is really similar to the first part, since all we're doing is storing two paths, just in different variables
            ;;
        3)

            mkdir "$backup_location/backup" #create target directory (doesnt rly work)
            
            echo "Starting backup..."
            
            #cp -r "/home/$USER/Downloads" "/$backup_location/backup" #cp -r copies files recursively ie all files in a directory, files within those directories
            
            tar -czvf "$backup_location/backup-$(date +%F).tar.gz" "$backup_path" 
            #tar creates archive files -c creates an archive -z uses gzip to compress -v for verbose, showing output in terminal, -f lets us specify file name
            sleep 5
            
            
            echo "Backup completed."
            
            ;;
        
        4)

            echo "Which archive would you like to restore?"

            while true; do
                read -r -p "Enter path to archive: " restore_path
                if [[ -f "$restore_path" ]]; then #checks if given path leads to a real file or not, if not a real file, loop until user enters a real file or quits
                    echo "File chosen to restore: $restore_path"
                    break
                else
                    echo "Error: not a file or archive, choose a valid archive"
                fi
            done
            
            echo "Unpacking...."
            sleep 1
            #create directory for restored files
            
            restore_name=$(basename "$restore_path" .tar.gz) #basename strips path and extentions from file
            
            restore_dir="$restore_name-Restored" #store name of new directory
            
            echo "$restore_dir" #testing
            
            mkdir "$restore_dir" #creates new directory with "Restored" added at the end
            
            tar -xf "$restore_path" -C "$restore_dir" #unpacks contents of user specified archive into newly created directory

            echo "Files extracted! (look inside this script's directory...)"



            ;;
        5)
            echo "Goodbye"
            exit 0
            
            ;;
        *)
            echo "Invalid option. Please choose 1-4."
            ;;
    esac
done
