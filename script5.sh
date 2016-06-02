#!/bin/bash
#
# Script 5 : varying L2 cache associativity
#
BENCHMARK=$(bash get_benchmark.sh)
VARIATION="l2_assoc"
echo "Launching test set 5 $VARIATION with benchmark $BENCHMARK"
source git_util.sh

export M5_PATH=/root/anthony/debian

# Benchmark main dir
BDIR="/root/anthony/lelec2990-sim2/$BENCHMARK"

# wait KVM simulation
KVMDIR="$BDIR/KVM"
while [ ! -f "$KVMDIR/done" ]
do
  sleep 2
done

# Launch for each protocol
for PROTOCOL in `ls -d /root/anthony/gem5/build/X86*`
do
    TPROTO=${PROTOCOL:25}
    
    # Check if no MI example
    if [ "$TPROTO" == "X86" ]; then
        continue
    fi
    
    # 8-way = default simulation
    TBDIR="$BDIR/$TPROTO/$VARIATION/8way"
    mkdir -p "$TBDIR"
    touch "$TBDIR/default"
    sync
    
    # 6-way L2
    TBDIR="$BDIR/$TPROTO/$VARIATION/6way"
    mkdir -p "$TBDIR"
    cp -r "$KVMDIR"/cpt* "$TBDIR/"
    "$PROTOCOL/gem5.opt" --outdir="$TBDIR" -e --stderr-file="$TBDIR/stderr.txt" -r --stdout-file="$TBDIR/stdout.txt" /root/anthony/gem5/configs/example/fs.py --mem-size 1GB --script /root/anthony/lelec2990-sim2/my_sim_script --num-cpus 4 --ruby -r 1 --restore-with-cpu timing --l2_assoc 6
    rm -rf "$TBDIR"/cpt*
    sync
    
    # 12-way L2
    TBDIR="$BDIR/$TPROTO/$VARIATION/12way"
    mkdir -p "$TBDIR"
    cp -r "$KVMDIR"/cpt* "$TBDIR/"
    "$PROTOCOL/gem5.opt" --outdir="$TBDIR" -e --stderr-file="$TBDIR/stderr.txt" -r --stdout-file="$TBDIR/stdout.txt" /root/anthony/gem5/configs/example/fs.py --mem-size 1GB --script /root/anthony/lelec2990-sim2/my_sim_script --num-cpus 4 --ruby -r 1 --restore-with-cpu timing --l2_assoc 12
    rm -rf "$TBDIR"/cpt*
    sync
done
