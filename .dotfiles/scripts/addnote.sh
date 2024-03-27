date=$(date +%Y-%m-%d);
time=$(date +%T);
base_dir="${HOME}/notes/weekly_notes"

week=$(date +%V);
file="$base_dir/week-$week.md"
last_week=$(date -v-1w +%V)
last_week_file="week-$last_week.md"
next_week=$(date -v+1w +%V)
next_week_file="week-$next_week.md"

other_args=""
list_type="-"
for arg in "$@"
do
    case $arg in
        --task)
            list_type="[ ] "
            ;;
        *)
            other_args+="$arg "
            ;;
    esac
done

default="# Week $week\n Last week: [[$last_week_file]], Next week: [[$next_week_file]]"

if [ ! -f "$file" ]; then
    echo "$default" > "$file"
fi

grep -q "$header" $file || echo "\n$header" >> $file;
sed -i "" "s/$header/&\n$list_type ${time}: $other_args/" $file; 
