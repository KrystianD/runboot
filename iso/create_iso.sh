#!/bin/bash
set -ex
cd "$(dirname "$0")"/..

OUTPUT_IMG_NAME=${OUTPUT_IMG_NAME:-runboot.iso}
OUTPUT_IMG_PATH=./output-iso/${OUTPUT_IMG_NAME}

KERNEL_IMAGES_PATH=./output-buildroot/images

DISKROOT_TMP_PATH=${DISKROOT_TMP_PATH:-./tmp-diskroot}

rm -rf "${DISKROOT_TMP_PATH}"
mkdir "${DISKROOT_TMP_PATH}"

cp -v -a --symbolic-link "$(pwd)"/diskroot/* "${DISKROOT_TMP_PATH}"

mkdir -p "${DISKROOT_TMP_PATH}"/boot/grub/ "${DISKROOT_TMP_PATH}"/EFI/BOOT

cp ${KERNEL_IMAGES_PATH}/bzImage "${DISKROOT_TMP_PATH}"/boot/linux
cp ${KERNEL_IMAGES_PATH}/rootfs.cpio.lz4 "${DISKROOT_TMP_PATH}"/boot/initrd
cp ./iso/grub.cfg "${DISKROOT_TMP_PATH}"/boot/grub/

MODULES=(
all_video boot cat chain configfile echo efi_gop efi_uga fat font gfxterm halt help iso9660 keystatus linux
linux16 loopback ls normal part_gpt part_msdos probe read reboot regexp test true udf search
linuxefi
)

grub-mkimage \
  --compression=xz \
  --config ./iso/grub-init.cfg \
  --format=x86_64-efi \
  --output="${DISKROOT_TMP_PATH}"/EFI/BOOT/bootx64.efi \
  --prefix=/boot/grub \
  "${MODULES[@]}"

MODULES=(
all_video linux normal iso9660 biosdisk memdisk search tar ls echo configfile fat part_gpt part_msdos help
)

grub-mkimage \
  --compression=xz \
  --config ./iso/grub-init.cfg \
  --format=i386-pc \
  --output=/tmp/grub.img \
  --prefix=/boot/grub \
  "${MODULES[@]}"

GRUB_CDBOOT_IMG=/usr/lib/grub/i386-pc/cdboot.img

cat ${GRUB_CDBOOT_IMG} /tmp/grub.img > "${DISKROOT_TMP_PATH}/boot/grub/grub.img"
rm -f /tmp/grub.img

EFIBOOT_PATH="${DISKROOT_TMP_PATH}/EFI/BOOT/efiboot.img"

truncate -s 1M "${EFIBOOT_PATH}"
mkfs.msdos -F 12 -n 'RUNBOOTISO' "${EFIBOOT_PATH}"
mmd -i "${EFIBOOT_PATH}" ::EFI
mmd -i "${EFIBOOT_PATH}" ::EFI/BOOT
mcopy -i "${EFIBOOT_PATH}" "${DISKROOT_TMP_PATH}/EFI/BOOT/bootx64.efi" ::EFI/BOOT/bootx64.efi

xorriso \
  -follow link \
  -as mkisofs \
  -o "${OUTPUT_IMG_PATH}" \
  -R -J -v -d -N \
  -hide-rr-moved \
  -boot-load-size 4 \
  -boot-info-table \
  -eltorito-boot boot/grub/grub.img \
  -no-emul-boot \
  -c boot/boot.cat \
  -eltorito-alt-boot \
  -eltorito-boot EFI/BOOT/efiboot.img \
  -no-emul-boot \
  -eltorito-platform efi \
  -V "RUNBOOTISO" \
  -A "runboot"  \
  "${DISKROOT_TMP_PATH}"
