#!/usr/bin/env sh


#// set variables

roconf="$HOME/.config/rofi/clipboard.rasi"

#// set rofi scaling

hypr_border="$(hyprctl -j getoption decoration:rounding | jq '.int')"
hypr_width="$(hyprctl -j getoption general:border_size | jq '.int')"

[[ "${rofiScale}" =~ ^[0-9]+$ ]] || rofiScale=10
r_scale="configuration {font: \"JetBrainsMono Nerd Font ${rofiScale}\";}"
wind_border=$((hypr_border * 3 / 2))
elem_border=$([ $hypr_border -eq 0 ] && echo "5" || echo $hypr_border)
r_override="window{border:${hypr_width}px;border-radius:${wind_border}px;} wallbox{border-radius:${elem_border}px;} element{border-radius:${elem_border}px;}"


#// clipboard action

case "${1}" in
c|-c|--copy)
    cliphist list | rofi -dmenu -theme-str "entry { placeholder: \"Copy...\";}" -theme-str "${r_scale}" -theme-str "${r_override}" -config "${roconf}" | cliphist decode | wl-copy
    ;;
d|-d|--delete)
    cliphist list | rofi -dmenu -theme-str "entry { placeholder: \"Delete...\";}" -theme-str "${r_scale}" -theme-str "${r_override}" -config "${roconf}" | cliphist delete
    ;;
w|-w|--wipe)
    if [ $(echo -e "Yes\nNo" | rofi -dmenu -theme-str "entry { placeholder: \"Clear Clipboard History?\";}" -theme-str "${r_scale}" -theme-str "${r_override}" -config "${roconf}") == "Yes" ] ; then
        cliphist wipe
    fi
    ;;
*)
    echo -e "cliphist.sh [action]"
    echo "c -c --copy    :  cliphist list and copy selected"
    echo "d -d --delete  :  cliphist list and delete selected"
    echo "w -w --wipe    :  cliphist wipe database"
    exit 1
    ;;
esac

