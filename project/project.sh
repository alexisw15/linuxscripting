#!/bin/bash

#put functions here










echo "Welcome to the file backup utility"
#!/bin/bash

echo "Welcome to the file backup utility"

while true; do
    echo "Please choose an option:"
    echo "1) Choose backup location"
    echo "2) Choose compression options"
    echo "3) Start backup"
    echo "4) Exit"
    read -p "Enter your choice: " choice

    case $choice in
        1)
            echo "Choose backup location (e.g., /home/user/backups):"
            while true; do
                read -p "Enter path: " backup_location #reads user input, in this case a path to a directory
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
            read -p "Compress files (y/N)? "
            case "$compress_choice" in
            [Yy]) compress=true;;
            *) compress=false;;
            esac
            echo "you chose $compress_choice"
            ;;
        3)
            # Add logic to perform the backup using the chosen location and compression
            echo "Starting backup..."
            # Simulating backup process
            sleep 2
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
