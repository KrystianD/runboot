#!/bin/bash
cd "$(dirname "$0")" || exit

mkdir -p output-buildroot/
touch output-buildroot/.config # workaround
docker run \
  --rm \
  -it \
  --user "$(id -u)" \
  -v "$(pwd)/output-buildroot:/tmp/build/" \
  -v "$(pwd)/cfg/:/cfg" \
  runboot-buildroot \
  menuconfig
