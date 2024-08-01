#!/usr/bin/env sh


#// set variables

roconf="/home/arman/.config/rofi/styles/style_6.rasi"

[[ "${rofiScale}" =~ ^[0-9]+$ ]] || rofiScale=10

#// set overrides

hypr_border="$(hyprctl -j getoption decoration:rounding | jq '.int')"
hypr_width="$(hyprctl -j getoption general:border_size | jq '.int')"

wind_border=$(( hypr_border * 3 ))
[ "${hypr_border}" -eq 0 ] && elem_border="10" || elem_border=$(( hypr_border * 2 ))
r_override="window {border: 2px; border-radius: ${wind_border}px;} element {border-radius: ${elem_border}px;}"
r_scale="configuration {font: \"JetBrainsMono Nerd Font ${rofiScale}\";}"
i_override="$(gsettings get org.gnome.desktop.interface icon-theme | sed "s/'//g")"
i_override="configuration {icon-theme: \"${i_override}\";}"


#// launch rofi

rofi -show "drun" -theme-str "${r_scale}" -theme-str "${r_override}" -theme-str "${i_override}" -config "${roconf}"

