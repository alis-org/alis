#!/usr/bin/bash
#
# DESCRIPTION
#
min_pack(){
  local name="installing minimal required packages"
  title "Start $name: $@"
  pacstrap  -C configs/etc/alis/pacstrap.conf "$mountpoint" base systemd-swap crda polkit linux linux-headers mkinitcpio \
                                                    btrfs-progs snapper intel-ucode broadcom-wl-dkms wpa_supplicant \
                                                    terminus-font zsh zsh-completions zsh-syntax-highlighting bash-completion \
                                                    gzip sed lzop nano iputils sudo wget intel-ucode \
                                                    dhcpcd man iproute2 pkgfile
}

export min_pack
