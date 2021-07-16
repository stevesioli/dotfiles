#!/bin/bash
# backup Home directory and

HOME_DIR="/Users/$(whoami)"
BACKUP_DIR="$HOME_DIR/Desktop"

# Do initial backup of Home directory excluding
# these files and directories
sudo tar -cvz \
--exclude=".*" \
--exclude="Applications" \
--exclude="Developer/repos" \
--exclude="Library/Caches" \
--exclude="Library/Developer" \
--exclude="Library/Logs" \
--exclude="Library/Messages" \
--exclude="Movies" \
--exclude="Music" \
--exclude="Pictures/Photos\ Library.photoslibrary" \
--exclude="Public" \
--exclude="Trash" \
-f "$BACKUP_DIR/home-backup.tar.gz" \
"$HOME_DIR/"

echo "Home backup complete!"
