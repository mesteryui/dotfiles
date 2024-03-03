#!/bin/env bash

# agosto 9 de 2023 - agrego una opcion de restart bspwm
# pues eliminé el atajo de teclado
# me parece peligroso en un directo o si estoy grabando

# opciones de powermenu-total
# presenta un menu sencillo hecho con rofi
# con tres opciones
# se hizo basado en un archivo de endeavour os bspwm
# y un script visto en github
# github.com/oberon-manjaro/oblogout-blurlock/blob/master/fluxboxexit
# de este último tomé los comandos para los if anidados
# en que dependiendo del gestor de ventanas
# doy el comando adecuado para salir
# solo funciona en sistemas con systemd

logout="  Cerrar Sesión"
reboot="  Reiniciar"
shutdown=" Apagar"
suspend=" Suspender"
# menu sencillo con rofi

selected_option=$(echo "$logout
$suspend
$reboot
$shutdown" | rofi -dmenu\
                -i\
                -p "Power"\
                -width "20"\
                -lines 4\
                -line-margin 3\
                -line-padding 10\
                -theme rounded-blue-dark\
                -scrollbar-with "0" )


#  Si es logout - cerrar sesión debo hacer unos if anidados
#  y el comando adecuado según el Gestor de Ventanas
if [ "$selected_option" == "$logout" ]
then
    if [ $DESKTOP_SESSION == "openbox" ]; then
     openbox --exit
    elif [ $DESKTOP_SESSION == "i3" ]; then
     i3-msg exit
    elif [ $DESKTOP_SESSION == "bspwm" ]; then
     bspc quit
    fi

#  Las opciones de roboot y shutdown son comunes a los 3 gestores
#  por supuesto si es que tenemos systemd

elif [ "$selected_option" == "$reboot" ]
then
     systemctl reboot
elif [ "$selected_option" == "$shutdown" ]
then
     systemctl poweroff
elif [ "$selected_option" == "$suspend" ]
then
    systemctl suspend
else
     echo "Cancelado"
fi
