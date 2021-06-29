FROM ubuntu:18.04

RUN export DEBIAN_FRONTEND=noninteractive; \
    apt-get update && \
    apt-get install -y software-properties-common wget curl apt-transport-https \
                       ovmf grub-pc-bin grub-efi-amd64-bin dosfstools mtools xorriso && \
    apt-get upgrade -y && apt-get clean && apt-get autoremove -y && rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["/src/iso/create_iso.sh"]
