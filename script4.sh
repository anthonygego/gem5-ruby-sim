#!/bin/bash
#
# Script 4 : varying L2 cache size
#
BENCHMARK=$(bash get_benchmark.sh)
VARIATION="l2_size"
echo "Launching test set 4 $VARIATION with benchmark $BENCHMARK"
source git_util.sh

export M5_PATH=/root/anthony/debian

# Benchmark main dir
BDIR="/root/anthony/lelec2990-sim2/$BENCHMARK"

# Launch KVM simulation
KVMDIR="$BDIR/KVM"
mkdir -p "$KVMDIR"
"/root/anthony/gem5/build/X86/gem5.opt" --outdir="$KVMDIR" -e --stderr-file="$KVMDIR/stderr.txt" -r --stdout-file="$KVMDIR/stdout.txt" /root/anthony/gem5/configs/example/fs.py --mem-size 1GB --script /root/anthony/lelec2990-sim2/my_sim_script --num-cpus 4 --cpu-type X86KvmCPU
touch "$KVMDIR"/done
sync

# Launch for each protocol
for PROTOCOL in `ls -d /root/anthony/gem5/build/X86*`
do
    TPROTO=${PROTOCOL:25}
    
    # Check if no MI example
    if [ "$TPROTO" == "X86" ]; then
        continue
    fi
    
    # 2MB = default simulation
    TBDIR="$BDIR/$TPROTO/$VARIATION/2MB"
    mkdir -p "$TBDIR"
    touch "$TBDIR/default"
    sync
    
    # 1MB L2 size
    TBDIR="$BDIR/$TPROTO/$VARIATION/1MB"
    mkdir -p "$TBDIR"
    cp -r "$KVMDIR"/cpt* "$TBDIR/"
    "$PROTOCOL/gem5.opt" --outdir="$TBDIR" -e --stderr-file="$TBDIR/stderr.txt" -r --stdout-file="$TBDIR/stdout.txt" /root/anthony/gem5/configs/example/fs.py --mem-size 1GB --script /root/anthony/lelec2990-sim2/my_sim_script --num-cpus 4 --ruby -r 1 --restore-with-cpu timing --l2_size 1MB
    rm -rf "$TBDIR"/cpt*
    sync
    
    # 4MB L2 size
    TBDIR="$BDIR/$TPROTO/$VARIATION/4MB"
    mkdir -p "$TBDIR"
    cp -r "$KVMDIR"/cpt* "$TBDIR/"
    "$PROTOCOL/gem5.opt" --outdir="$TBDIR" -e --stderr-file="$TBDIR/stderr.txt" -r --stdout-file="$TBDIR/stdout.txt" /root/anthony/gem5/configs/example/fs.py --mem-size 1GB --script /root/anthony/lelec2990-sim2/my_sim_script --num-cpus 4 --ruby -r 1 --restore-with-cpu timing --l2_size 4MB
    rm -rf "$TBDIR"/cpt*
    sync
done
