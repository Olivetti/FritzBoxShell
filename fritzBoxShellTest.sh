#!/bin/bash
# shellcheck disable=SC1090
#************************************************************#
#** Autor: Jürgen Key https://elbosso.github.io/index.html **#
#** Autor: Johannes Hubig <johannes.hubig@gmail.com>       **#
#************************************************************#

# The following script is supposed to test what actions are
# supported by what device with what version of the firmware

dir=$(dirname "$0")

DIRECTORY=$(cd "$dir" && pwd)
source "$DIRECTORY/fritzBoxShellConfig.sh"

## declare an array variable
declare -a services=("WLAN_2G"   "WLAN_2G" "WLAN_5G"    "WLAN_5G" "WLAN"  "LAN"   "DSL"   "WAN"   "LINK"  "IGDWAN" "IGDDSL" "IGDIP" "TAM" "OnTel")
declare -a actions=("STATISTICS" "STATE"   "STATISTICS" "STATE"   "STATE" "STATE" "STATE" "STATE" "STATE" "STATE"  "STATE"  "STATE" "0 GetInfo" "GetCallList 1")
declare -a minwords=(3           5         3            5         9       1       1       1       1       1        1        1       5      1)

## now loop through the above array
counter=0
for i in "${services[@]}"
do
    printf "%-20s" "${i} ${actions[$counter]}"
    words=$(/bin/bash "$DIRECTORY/fritzBoxShell.sh" "${i}" "${actions[$counter]}" | wc -w)
    #echo -n $words
    [[ "$words" -ge ${minwords[$counter]} ]] && echo "yes" || echo "no"
    counter=$((counter+1))
done
 
DI=$(/bin/bash "$DIRECTORY/fritzBoxShell.sh" DEVICEINFO 3)
for j in 'NewModelName' 'NewSoftwareVersion'
do
    _DI=$(grep ${j} <<<${DI})
    printf "%-19s %s\n" "$(cut -d' ' -f1 <<<${_DI})" "$(cut -d' ' -f2- <<<${_DI})"
done
 
VERS=$(/bin/bash "$DIRECTORY/fritzBoxShell.sh" VERSION)
printf "%-19s v%s\n" "$(cut -d' ' -f1 <<<${VERS})" "$(cut -d' ' -f3 <<<${VERS})"
