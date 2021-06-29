#!/bin/bash
cd "$(dirname "$0")" || exit

if [ "$1" = "cdrom-pc" ]; then
  qemu-system-x86_64 -snapshot -enable-kvm -m 1000 -cdrom output-iso/runboot.iso

elif [ "$1" = "cdrom-efi" ]; then
  qemu-system-x86_64 -snapshot -enable-kvm -m 1000 -cdrom output-iso/runboot.iso -bios /usr/share/edk2-ovmf/x64/OVMF.fd

elif [ "$1" = "hda-pc" ]; then
  qemu-system-x86_64 -snapshot -enable-kvm -m 1000 -hda output-iso/runboot.iso

elif [ "$1" = "hda-efi" ]; then
  qemu-system-x86_64 -snapshot -enable-kvm -m 1000 -hda output-iso/runboot.iso -bios /usr/share/edk2-ovmf/x64/OVMF.fd

else
  echo "specify cdrom-pc, cdrom-efi, hda-pc or hda-efi"
fi
