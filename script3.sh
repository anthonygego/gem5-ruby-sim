#!/bin/bash
#
# Script 3 : varying L1D cache associativity
#
BENCHMARK=$(bash get_benchmark.sh)
VARIATION="l1d_assoc"
echo "Launching test set 3 $VARIATION with benchmark $BENCHMARK"
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
    
    # 2-way = default simulation
    TBDIR="$BDIR/$TPROTO/$VARIATION/2way"
    mkdir -p "$TBDIR"
    touch "$TBDIR/default"
    sync
    
    # 4-way L1D
    TBDIR="$BDIR/$TPROTO/$VARIATION/4way"
    mkdir -p "$TBDIR"
    cp -r "$KVMDIR"/cpt* "$TBDIR/"
    "$PROTOCOL/gem5.opt" --outdir="$TBDIR" -e --stderr-file="$TBDIR/stderr.txt" -r --stdout-file="$TBDIR/stdout.txt" /root/anthony/gem5/configs/example/fs.py --mem-size 1GB --script /root/anthony/lelec2990-sim2/my_sim_script --num-cpus 4 --ruby -r 1 --restore-with-cpu timing --l1d_assoc 4
    rm -rf "$TBDIR"/cpt*
    sync
    
    # 8-way L1D
    TBDIR="$BDIR/$TPROTO/$VARIATION/8way"
    mkdir -p "$TBDIR"
    cp -r "$KVMDIR"/cpt* "$TBDIR/"
    "$PROTOCOL/gem5.opt" --outdir="$TBDIR" -e --stderr-file="$TBDIR/stderr.txt" -r --stdout-file="$TBDIR/stdout.txt" /root/anthony/gem5/configs/example/fs.py --mem-size 1GB --script /root/anthony/lelec2990-sim2/my_sim_script --num-cpus 4 --ruby -r 1 --restore-with-cpu timing --l1d_assoc 8
    rm -rf "$TBDIR"/cpt*
    sync
done
