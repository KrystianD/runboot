FROM ubuntu:18.04

RUN export DEBIAN_FRONTEND=noninteractive; \
    apt-get update && \
    apt-get install -y software-properties-common wget curl apt-transport-https \
                       build-essential unzip libssl-dev libelf-dev cpio bc rsync libncurses-dev && \
    apt-get upgrade -y && apt-get clean && apt-get autoremove -y && rm -rf /var/lib/apt/lists/*

WORKDIR /src

ARG BR2_VERSION=2021.02-rc1
RUN wget https://buildroot.org/downloads/buildroot-$BR2_VERSION.tar.bz2 && \
    tar --strip-component=1 -xf buildroot-$BR2_VERSION.tar.bz2 && \
    rm -f buildroot-$BR2_VERSION.tar.bz2

COPY entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
CMD ["build"]
