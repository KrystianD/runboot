runboot
=====

A tool for creating small bootable Linux images that can do something right after they boot up.

For example, it can create a bootable USB Flash Drive that will run a Python script which copies some files from the boot medium to the hard disk.

It utilizes Buildroot, GRUB and tools for creating ISO images.

### Usage

Everything is set up to run under Docker, which is the only requirement on the host system.

1. Build Docker images:

```shell
./1_build_images.sh
```

2. (optional) Make adjustment to Buildroot (via menuconfig):

```shell
./menuconfig.sh
```

3. Build kernel and rootfs with Buildroot:

```shell
./2_run_buildroot.sh
```

4. Copy your files to `diskroot/` directory. After booting, runboot will run `run.sh`.

5. Create ISO image:

```shell
./3_create_iso.sh
```

Optionally, path to diskroot can be provided as first argument of `3_create_iso.sh` script.

Image will be placed in `output-iso/` directory.

6. (optional) Test your ISO image with QEMU:

```shell
./run_in_qemu.sh cdrom-pc # or cdrom-efi, hda-pc, hda-efi
```

### Supports

- BIOS and UEFI modes in a single image,
- booting from USB Flash Drive, CD-ROM drive or a hard disk.

### Example

Default repository configuration creates a bootable image that shows Hello World from a Python script and reboots the system.
