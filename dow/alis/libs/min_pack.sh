#!/usr/bin/bash
#
# DESCRIPTION
#
min_pack(){
  local name="installing minimal required packages"
  title "Start $name: $@"
  pacstrap  -C configs/etc/alis/pacstrap.conf "$mountpoint" base base-devel systemd-swap crda polkit mkinitcpio btrfs-progs snapper intel-ucode broadcom-wl-dkms wpa_supplicant \
                                                    terminus-font zsh zsh-completions zsh-syntax-highlighting bash-completion wget intel-ucode dhcpcd man iproute2 pkgfile git \
                                                    weston qt5-wayland gtk3 libva-intel-driver vulkan-intel rsync tmux
}

export min_pack
