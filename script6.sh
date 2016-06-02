#!/bin/bash
#
# Script 6 : varying number of dirs
#
BENCHMARK=$(bash get_benchmark.sh)
VARIATION="num-dirs"
echo "Launching test set 6 $VARIATION with benchmark $BENCHMARK"
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
    
    # 1dir = default simulation
    TBDIR="$BDIR/$TPROTO/$VARIATION/1dir"
    mkdir -p "$TBDIR"
    touch "$TBDIR/default"
    sync
    
    # 2dir
    TBDIR="$BDIR/$TPROTO/$VARIATION/2dir"
    mkdir -p "$TBDIR"
    cp -r "$KVMDIR"/cpt* "$TBDIR/"
    "$PROTOCOL/gem5.opt" --outdir="$TBDIR" -e --stderr-file="$TBDIR/stderr.txt" -r --stdout-file="$TBDIR/stdout.txt" /root/anthony/gem5/configs/example/fs.py --mem-size 1GB --script /root/anthony/lelec2990-sim2/my_sim_script --num-cpus 4 --ruby -r 1 --restore-with-cpu timing --num-dirs 2
    rm -rf "$TBDIR"/cpt*
    sync
    
    # 4dir
    TBDIR="$BDIR/$TPROTO/$VARIATION/4dir"
    mkdir -p "$TBDIR"
    cp -r "$KVMDIR"/cpt* "$TBDIR/"
    "$PROTOCOL/gem5.opt" --outdir="$TBDIR" -e --stderr-file="$TBDIR/stderr.txt" -r --stdout-file="$TBDIR/stdout.txt" /root/anthony/gem5/configs/example/fs.py --mem-size 1GB --script /root/anthony/lelec2990-sim2/my_sim_script --num-cpus 4 --ruby -r 1 --restore-with-cpu timing --num-dirs 4
    rm -rf "$TBDIR"/cpt*
    sync
done
