#!/bin/bash

BENCHMARK=$(bash get_benchmark.sh)

# Prepare the simulation script
sed "s/PRG_NAME/$BENCHMARK/g" sim_script > /root/anthony/lelec2990-sim2/my_sim_script

# Source and determine the script to launch
declare -A scr=( ["virunga"]="script1.sh"
                 ["calbuco"]="script2.sh"
                 ["bibinoi"]="script3.sh script5.sh" 
                 ["bulusan"]="script4.sh script6.sh"
                 ["tsurumi"]="script1.sh" 
                 ["cayambe"]="script2.sh"
                 ["khangar"]="script3.sh script5.sh"
                 ["yunaska"]="script4.sh script6.sh"
                 ["trident"]="script1.sh"
                 ["tibesti"]="script2.sh"
                 ["baluran"]="script3.sh script5.sh"
                 ["davidof"]="script4.sh script6.sh"
                 ["denison"]="script1.sh" 
                 ["chacana"]="script2.sh"
                 ["furnas"]="script3.sh script5.sh"
                 ["colachi"]="script4.sh script6.sh"
               )

HOSTNAME=$(hostname)
HOSTNAME=${HOSTNAME::-15}
SCRIPTS=${scr["$HOSTNAME"]}

#Launch the simulations
for SCRIPT in $SCRIPTS
do
    chmod +x "$SCRIPT"
    bash "$SCRIPT"
done


