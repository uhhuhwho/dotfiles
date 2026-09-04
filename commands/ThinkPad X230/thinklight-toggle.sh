#!/bin/bash
EC=/sys/kernel/debug/ec/ec0/io

# make sure ec_sys is loaded with write support
if ! lsmod | grep -q ec_sys; then
    sudo modprobe ec_sys write_support=1
fi

# read current byte at 0x3B
current=$(sudo dd if="$EC" bs=1 count=1 skip=$((0x3B)) 2>/dev/null | xxd -p)

if [ "$current" = "12" ]; then
    printf '\x10' | sudo dd of="$EC" bs=1 seek=$((0x3B)) conv=notrunc 2>/dev/null
else
    printf '\x12' | sudo dd of="$EC" bs=1 seek=$((0x3B)) conv=notrunc 2>/dev/null
fi