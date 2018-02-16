#!/usr/bin/bash
#
# DESCRIPTION
#
min_pack(){
  local name="installing minimal required packages"
  title "Start $name: $@"
  pacstrap  -C configs/etc/alis/pacstrap.conf "$mountpoint" base systemd-swap crda polkit linux linux-headers mkinitcpio \
                                                    btrfs-progs snapper intel-ucode vulkan-intel libva-intel-driver broadcom-wl-dkms wpa_supplicant \
                                                    terminus-font zsh zsh-completions zsh-syntax-highlighting bash-completion \
                                                    gzip sed lzop nano iputils sudo wget efibootmgr efitools sbsigntools \
                                                    man iproute2 pkgfile xdelta3 grc modprobed-db plymouth systemd-boot-password
}

export min_pack
