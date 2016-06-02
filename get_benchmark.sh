#!/bin/bash
# Source and determine benchmark
declare -A bms=( ["virunga"]="fluidanimate" 
                 ["calbuco"]="fluidanimate"
                 ["bibinoi"]="fluidanimate" 
                 ["bulusan"]="fluidanimate"
                 ["tsurumi"]="splash2x.raytrace" 
                 ["cayambe"]="splash2x.raytrace"
                 ["khangar"]="splash2x.raytrace" 
                 ["yunaska"]="splash2x.raytrace"
                 ["trident"]="canneal" 
                 ["tibesti"]="canneal"
                 ["baluran"]="canneal" 
                 ["davidof"]="canneal"
                 ["denison"]="splash2x.fmm" 
                 ["chacana"]="splash2x.fmm"
                 ["furnas"]="splash2x.fmm" 
                 ["colachi"]="splash2x.fmm"
               )
HOSTNAME=$(hostname)
HOSTNAME=${HOSTNAME::-15}
echo "${bms["$HOSTNAME"]}"