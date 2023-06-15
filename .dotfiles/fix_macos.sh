
# Settings
defaults write us.zoom.xos NSQuitAlwaysKeepsWindows 0
# Echos

echo "This is some manual stuff. You can probably program this once you feel like it."
echo "- Disable login items:"
echo "  System Preferences > Users & Groups > Login Items"
#Todo already got bored
#
crontab -l | {
    cat;
 echo "0 * * * * osascript -e 'display notification \"Whatcha doin?\" with title \"Oi, you there\"'";
 echo "0 * * * * osascript -e 'display notification \"Did'cha try committing it?\" with title \"Oi, you git\"'"
} | crontab -
