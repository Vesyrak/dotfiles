date=$(date +%Y-%m-%d);
time=$(date +%T);
base_dir="${HOME}/notes/weekly_notes"

week=$(date +%V-%Y);
file="$base_dir/week-$week.md"
last_week=$(date -v-1w +%V-%Y)
last_week_file="week-$last_week.md"
next_week=$(date -v+1w +%V-%Y)
next_week_file="week-$next_week.md"

content=""
list_type="-"
while [[ $# -gt 0 ]]; do
    case $1 in
        --task)
            list_type="[ ]"
            time=$date
            shift
            ;;
        --header)
            header="$2"
            shift
            shift
            ;;
        *)
            content+="$1 "
            shift
            ;;
    esac
done


if [ ! -f $file ]; then
    default="# Week $week\nLast week: [[$last_week_file]], Next week: [[$next_week_file]]\n\n"

    default="${default}## $(date -vmon +%a\ %Y-%m-%d)\n\n"
    default="${default}## $(date -vtue +%a\ %Y-%m-%d)\n\n"
    default="${default}## $(date -vwed +%a\ %Y-%m-%d)\n\n"
    default="${default}## $(date -vthu +%a\ %Y-%m-%d)\n\n"
    default="${default}## $(date -vfri +%a\ %Y-%m-%d)\n\n"
    default="${default}## $(date -vsat +%a\ %Y-%m-%d)\n\n"
    default="${default}## $(date -vsun +%a\ %Y-%m-%d)\n\n"

    default="${default}# TODO\n\n"
    default="${default}## Previous TODOs\n\n"
    previous_todos=$(grep -N "^\s*\[ \]" ~/notes/weekly_notes/week-13-2024.md)  
    default="${default}${previous_todos}\n\n"

    default="${default}# Improvements\n\n"

    echo $default > $file


fi


grep -q "$header" $file || echo "\n$header" >> $file;
gawk -i inplace "/$header$/ {print; print \"$list_type $time: $content\"; next} 1" $file
