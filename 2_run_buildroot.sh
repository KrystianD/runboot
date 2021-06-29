#!/bin/bash
cd "$(dirname "$0")" || exit

mkdir -p output-buildroot/ cache-dl/ cache-ccache/
touch output-buildroot/.config # workaround
docker run \
  --rm \
  -it \
  --user "$(id -u)" \
  -v "$(pwd)/cfg/:/cfg:ro" \
  -v "$(pwd)/output-buildroot:/tmp/build/" \
  -v "$(pwd)/cache-dl:/tmp/dl/" \
  -v "$(pwd)/cache-ccache:/tmp/ccache/" \
  runboot-buildroot
