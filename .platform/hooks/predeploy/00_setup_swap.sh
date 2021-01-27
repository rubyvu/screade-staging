#!/bin/bash

SWAPFILE=/var/swapfile
SWAP_MEGABYTES=4096

if [ -f $SWAPFILE ]; then
  echo "Swapfile $SWAPFILE found, skipping"
else
  /bin/dd if=/dev/zero of=$SWAPFILE bs=1M count=$SWAP_MEGABYTES
  /bin/chmod 600 $SWAPFILE
  /sbin/mkswap $SWAPFILE
  /sbin/swapon $SWAPFILE
fi
