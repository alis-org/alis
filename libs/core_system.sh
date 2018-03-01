#!/usr/bin/bash
#
# DESCRIPTION
#
core_system(){
  local name="installing minimal required packages"
  title "Start $name: $@"

 pacstrap  -C configs/etc/pacman.d/pacstrap.conf "$mountpoint" linux linux-headers linux-docs crda \
                                                           systemd systemd-sysvcompat libmicrohttpd systemd-swap quota-tools polkit \
                                                           btrfs-progs snapper dosfstools snap-pac \
                                                           iputils inetutils iproute2 util-linux psmisc procps-ng pciutils coreutils findutils sysfsutils usbutils util-linux binutils \
                                                           terminus-font ttf-dejavu ttf-hack xorg-fonts-alias \
                                                           pacman pkgfile \
                                                           man-db man-pages \
                                                           less lesspipe source-highlight tmux gawk grep sed tar lzop which  tree \
                                                           shadow \
                                                           bash bash-completion zsh zsh-completions zsh-syntax-highlighting grml-zsh-config \
                                                           bzip2 gzip lzop lz4 xz \
                                                           cryptsetup device-mapper \
                                                           file filesystem \
                                                           gcc-libs gettext glibc \
                                                           nano \
                                                           logrotate \
                                                           intel-ucode vulkan-intel libva-intel-driver broadcom-wl-dkms \
                                                           wpa_supplicant wireless_tools \
                                                           efibootmgr efitools sbsigntools \
                                                           sudo wget git xdelta3
}

export core_systemd

