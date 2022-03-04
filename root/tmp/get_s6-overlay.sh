#!/bin/sh

if [ -n $ARCH ]
then
  s6_arch=$ARCH
else
  s6_arch="amd64"
fi

case "$s6_arch" in
  arm-v7)
    s6_arch="armhf"
    ;;
  arm64)
    s6_arch="aarch64"
    ;;
  amd64)
    s6_arch="x86_64"
    ;;
esac
curl -sX GET "https://api.github.com/repos/just-containers/s6-overlay/releases/latest" | awk '/tag_name/{print $4;exit}' FS='[""]' >/etc/S6_RELEASE && \
s6_arch_url="https://github.com/just-containers/s6-overlay/releases/download/`cat /etc/S6_RELEASE`/s6-overlay-$s6_arch-`cat /etc/S6_RELEASE | sed 's/v//'`.tar.xz"
s6_noarch_url="https://github.com/just-containers/s6-overlay/releases/download/`cat /etc/S6_RELEASE`/s6-overlay-noarch-`cat /etc/S6_RELEASE | sed 's/v//'`.tar.xz"
s6_symlinks_arch_url="https://github.com/just-containers/s6-overlay/releases/download/`cat /etc/S6_RELEASE`/s6-overlay-$s6_arch-`cat /etc/S6_RELEASE | sed 's/v//'`.tar.xz"
s6_symlinks_noarch_url="https://github.com/just-containers/s6-overlay/releases/download/`cat /etc/S6_RELEASE`/s6-overlay-noarch-`cat /etc/S6_RELEASE | sed 's/v//'`.tar.xz"
echo "Downloading from $s6_noarch_url" && \
wget $s6_arch_url -O /tmp/s6-overlay-noarch.tar.xz && \
tar xJf /tmp/s6-overlay-noarch.tar.xz -C / && \
rm /tmp/s6-overlay-noarch.tar.xz && \
echo "Downloading from $s6_arch_url" && \
wget $s6_arch_url -O /tmp/s6-overlay-${s6_arch}.tar.xz && \
tar xJf /tmp/s6-overlay-${s6_arch}.tar.xz -C / && \
rm /tmp/s6-overlay-${s6_arch}.tar.xz && \
echo "Downloading from $s6_symlinks_noarch_url" && \
wget $s6_arch_url -O /tmp/s6-overlay-symlinks-noarch.tar.xz && \
tar xJf /tmp/s6-overlay-symlinks-noarch.tar.xz -C / && \
rm /tmp/s6-overlay-symlinks-noarch.tar.xz && \
echo "Downloading from $s6_symlinks_arch_url" && \
wget $s6_arch_url -O /tmp/s6-overlay-symlinks-arch.tar.xz && \
tar xJf /tmp/s6-overlay-symlinks-arch.tar.xz -C / && \
rm /tmp/s6-overlay-symlinks-arch.tar.xz && \
echo "Installed s6-overlay `cat /etc/S6_RELEASE` ($s6_arch)"
