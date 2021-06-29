#!/bin/bash
cd "$(dirname "$0")" || exit

NAME=runboot.iso
DISKROOT_DEFAULT=$(pwd)/diskroot
DISKROOT=${1:-${DISKROOT_DEFAULT}}

if [ ! -e "${DISKROOT}" ]; then
  echo "Path '$DISKROOT' doesn't exist"
  exit 1
fi

mkdir -p output-iso/
docker run \
  --rm \
  -it \
  --user $(id -u) \
  -e OUTPUT_IMG_NAME=$NAME \
  -e DISKROOT_TMP_PATH=/tmp/diskroot \
  -v "$(pwd)/output-buildroot:/src/output-buildroot:ro" \
  -v "$(pwd)/iso:/src/iso:ro" \
  -v "${DISKROOT}:/src/diskroot:ro" \
  -v "$(pwd)/output-iso:/src/output-iso" \
  runboot-iso
