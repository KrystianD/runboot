#!/bin/bash
export BR2_DL_DIR=/tmp/dl
export BR2_CCACHE_DIR=/tmp/ccache

if [ "$1" = "menuconfig" ]; then
  make CONFIG_DIR=/cfg O=/tmp/build menuconfig
fi

if [ "$1" = "build" ]; then
  make CONFIG_DIR=/cfg O=/tmp/build
fi
