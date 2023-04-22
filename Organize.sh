#!/bin/bash

# 1. The script starts by setting the DOWNLOADS_DIRECTORY variable to the path of the user's Downloads directory ($HOME/Downloads).
DOWNLOADS_DIRECTORY="$HOME/Downloads"

# 2. Then, the script checks if the Images, Documents, Videos, Music, and Others directories exist in the Downloads directory. If they don't exist, the script creates them using the mkdir -p command.
if [ ! -d "$DOWNLOADS_DIRECTORY/Images" ]; then
    mkdir -p "$DOWNLOADS_DIRECTORY/Images"
fi

if [ ! -d "$DOWNLOADS_DIRECTORY/Documents" ]; then
    mkdir -p "$DOWNLOADS_DIRECTORY/Documents"
fi

if [ ! -d "$DOWNLOADS_DIRECTORY/Videos" ]; then
    mkdir -p "$DOWNLOADS_DIRECTORY/Videos"
fi

if [ ! -d "$DOWNLOADS_DIRECTORY/Music" ]; then
    mkdir -p "$DOWNLOADS_DIRECTORY/Music"
fi

if [ ! -d "$DOWNLOADS_DIRECTORY/Others" ]; then
    mkdir -p "$DOWNLOADS_DIRECTORY/Others"
fi

if [ ! -d "$DOWNLOADS_DIRECTORY/Iso" ]; then
    mkdir -p "$DOWNLOADS_DIRECTORY/Iso"
fi

if [ ! -d "$DOWNLOADS_DIRECTORY/Compressed" ]; then
    mkdir -p "$DOWNLOADS_DIRECTORY/Compressed"
fi

# 3. The script then uses a for loop to iterate through all files in the Downloads directory. For each file, the script checks if it's a regular file using the -f test.

#4. If the file is a regular file, the script uses the ${file##*.} parameter expansion to extract the file extension and saves it in the extension variable.

#5. The script then uses a case statement to check the extension of the file and move it to the corresponding directory based on its extension. If the extension doesn't match any of the defined cases, it is moved to the Others directory.

#6. The script uses the mv -i command to move the files to their respective directories, with the -i option to prompt the user before overwriting any files with the same name.

for file in "$DOWNLOADS_DIRECTORY"/*; do
    if [ -f "$file" ]; then
        extension="${file##*.}"
        case "$extension" in
            jpg|jpeg|png|gif)
                mv -i "$file" "$DOWNLOADS_DIRECTORY/Images/$(basename "$file")"
                ;;
            pdf|doc|docx|txt|pptx)
                mv -i "$file" "$DOWNLOADS_DIRECTORY/Documents/$(basename "$file")"
                ;;
            mp4|avi|mov|wmv)
                mv -i "$file" "$DOWNLOADS_DIRECTORY/Videos/$(basename "$file")"
                ;;
            mp3|wav|flac|aac)
                mv -i "$file" "$DOWNLOADS_DIRECTORY/Music/$(basename "$file")"
                ;;
            img|iso)
                mv -i "$file" "$DOWNLOADS_DIRECTORY/Iso/$(basename "$file")"
                ;;
            rar|zip|7z|gz)
                mv -i "$file" "$DOWNLOADS_DIRECTORY/Compressed/$(basename "$file")"
                ;;
            *)
                mv -i "$file" "$DOWNLOADS_DIRECTORY/Others/$(basename "$file")"
                ;;
        esac
    fi
done

# To run this script, you have to give it permission to run using the chmod command in the terminal:
# chmod +x Organize.sh

# Then you can run it with the following command in the terminal:
# ./Organize.sh
