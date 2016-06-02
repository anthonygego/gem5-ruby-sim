#!/bin/bash
#
# Script 1 : DEFAULT + varying cache line size
#
BENCHMARK=$(bash get_benchmark.sh)
VARIATION="cacheline_size"
echo "Launching test set 1 $VARIATION with benchmark $BENCHMARK"
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
    
    # 64B cache line/default simulation
    TBDIR="$BDIR/$TPROTO/$VARIATION/64b"
    mkdir -p "$TBDIR"
    cp -r "$KVMDIR"/cpt* "$TBDIR/"
    "$PROTOCOL/gem5.opt" --outdir="$TBDIR" -e --stderr-file="$TBDIR/stderr.txt" -r --stdout-file="$TBDIR/stdout.txt" /root/anthony/gem5/configs/example/fs.py --mem-size 1GB --script /root/anthony/lelec2990-sim2/my_sim_script --num-cpus 4 --ruby -r 1 --restore-with-cpu timing --cacheline_size 64 
    rm -rf "$TBDIR"/cpt*
    ln -s "$TBDIR" "$BDIR/$TPROTO/default"
    sync
    
    # 32B cache line
    TBDIR="$BDIR/$TPROTO/$VARIATION/32b"
    mkdir -p "$TBDIR"
    cp -r "$KVMDIR"/cpt* "$TBDIR/"
    "$PROTOCOL/gem5.opt" --outdir="$TBDIR" -e --stderr-file="$TBDIR/stderr.txt" -r --stdout-file="$TBDIR/stdout.txt" /root/anthony/gem5/configs/example/fs.py --mem-size 1GB --script /root/anthony/lelec2990-sim2/my_sim_script --num-cpus 4 --ruby -r 1 --restore-with-cpu timing --cacheline_size 32
    rm -rf "$TBDIR"/cpt*
    sync
    
    # 128B cache line
    TBDIR="$BDIR/$TPROTO/$VARIATION/128b"
    mkdir -p "$TBDIR"
    cp -r "$KVMDIR"/cpt* "$TBDIR/"
    "$PROTOCOL/gem5.opt" --outdir="$TBDIR" -e --stderr-file="$TBDIR/stderr.txt" -r --stdout-file="$TBDIR/stdout.txt" /root/anthony/gem5/configs/example/fs.py --mem-size 1GB --script /root/anthony/lelec2990-sim2/my_sim_script --num-cpus 4 --ruby -r 1 --restore-with-cpu timing --cacheline_size 128 
    rm -rf "$TBDIR"/cpt*
    sync
done
