#!/usr/bin/bash
#
# DESCRIPTION
#
setup_rollback_layout(){
  arch-chroot "$mountpoint"  snapper -v --no-dbus -c root      create-config -t root-template /
  arch-chroot "$mountpoint"  snapper -v --no-dbus -c home      create-config -t home-template /home
  arch-chroot "$mountpoint"  snapper -v --no-dbus -c srv       create-config /srv
  arch-chroot "$mountpoint"  snapper -v --no-dbus -c opt       create-config /opt
  arch-chroot "$mountpoint"  snapper -v --no-dbus -c usr_local create-config /usr/local
  arch-chroot "$mountpoint"  snapper -v --no-dbus -c var_tmp   create-config /var/tmp
  arch-chroot "$mountpoint"  snapper -v --no-dbus -c var_opt   create-config /var/opt
  arch-chroot "$mountpoint"  snapper -v --no-dbus -c var_log   create-config /var/log
  arch-chroot "$mountpoint"  snapper -v --no-dbus -c var_cache create-config /var/cache

  arch-chroot "$mountpoint"  btrfs subvolume delete /.snapshots
  arch-chroot "$mountpoint"  btrfs subvolume delete /home/.snapshots
  arch-chroot "$mountpoint"  btrfs subvolume delete /srv/.snapshots
  arch-chroot "$mountpoint"  btrfs subvolume delete /opt/.snapshots
  arch-chroot "$mountpoint"  btrfs subvolume delete /usr/local/.snapshots
  arch-chroot "$mountpoint"  btrfs subvolume delete /var/tmp/.snapshots
  arch-chroot "$mountpoint"  btrfs subvolume delete /var/opt/.snapshots
  arch-chroot "$mountpoint"  btrfs subvolume delete /var/log/.snapshots
  arch-chroot "$mountpoint"  btrfs subvolume delete /var/cache/.snapshots

  arch-chroot "$mountpoint"  mkdir -v -p /.snapshots
  arch-chroot "$mountpoint"  mkdir -v -p /home/.snapshots
  arch-chroot "$mountpoint"  mkdir -v -p /srv/.snapshots
  arch-chroot "$mountpoint"  mkdir -v -p /opt/.snapshots
  arch-chroot "$mountpoint"  mkdir -v -p /usr/local/.snapshots
  arch-chroot "$mountpoint"  mkdir -v -p /var/tmp/.snapshots
  arch-chroot "$mountpoint"  mkdir -v -p /var/opt/.snapshots
  arch-chroot "$mountpoint"  mkdir -v -p /var/log/.snapshots
  arch-chroot "$mountpoint"  mkdir -v -p /var/cache/.snapshots

  arch-chroot "$mountpoint"  chmod 750 /.snapshots
  arch-chroot "$mountpoint"  chmod 750 /home/.snapshots
  arch-chroot "$mountpoint"  chmod 750 /srv/.snapshots
  arch-chroot "$mountpoint"  chmod 750 /opt/.snapshots
  arch-chroot "$mountpoint"  chmod 750 /usr/local/.snapshots
  arch-chroot "$mountpoint"  chmod 750 /var/tmp/.snapshots
  arch-chroot "$mountpoint"  chmod 750 /var/opt/.snapshots
  arch-chroot "$mountpoint"  chmod 750 /var/log/.snapshots
  arch-chroot "$mountpoint"  chmod 750 /var/cache/.snapshots

  arch-chroot "$mountpoint"  mount -t btrfs -o subvol=/snapshots/snapper_root,"$os_part_opts"        "/dev/mapper/$luks_device"   /.snapshots
  arch-chroot "$mountpoint"  mount -t btrfs -o subvol=/snapshots/snapper_home,"$os_part_opts"        "/dev/mapper/$luks_device"   /home/.snapshots
  arch-chroot "$mountpoint"  mount -t btrfs -o subvol=/snapshots/snapper_srv,"$os_part_opts"         "/dev/mapper/$luks_device"   /srv/.snapshots
  arch-chroot "$mountpoint"  mount -t btrfs -o subvol=/snapshots/snapper_opt,"$os_part_opts"         "/dev/mapper/$luks_device"   /opt/.snapshots
  arch-chroot "$mountpoint"  mount -t btrfs -o subvol=/snapshots/usr/snapper_local,"$os_part_opts"   "/dev/mapper/$luks_device"   /usr/local/.snapshots
  arch-chroot "$mountpoint"  mount -t btrfs -o subvol=/snapshots/var/snapper_tmp,"$os_part_opts"     "/dev/mapper/$luks_device"   /var/tmp/.snapshots
  arch-chroot "$mountpoint"  mount -t btrfs -o subvol=/snapshots/var/snapper_opt,"$os_part_opts"     "/dev/mapper/$luks_device"   /var/opt/.snapshots
  arch-chroot "$mountpoint"  mount -t btrfs -o subvol=/snapshots/var/snapper_log,"$os_part_opts"     "/dev/mapper/$luks_device"   /var/log/.snapshots
  arch-chroot "$mountpoint"  mount -t btrfs -o subvol=/snapshots/var/snapper_cache,"$os_part_opts"   "/dev/mapper/$luks_device"   /var/cache/.snapshots

  arch-chroot "$mountpoint"  btrfs subvolume set-default 257 /

  if [ $? -eq 0 ]; then
    msg "Rollback layout is good";
  else
    die "Rollback is bad";
  fi
}

setup_pacman(){
  arch-chroot "$mountpoint" pacman-key --init
  arch-chroot "$mountpoint" pacman-key --populate archlinux
  arch-chroot "$mountpoint" pacman-optimize

  if [ $? -eq 0 ]; then
    msg "Pacman is good";
  else
    die "Pacman is bad";
  fi
}

enable_network_services(){
  arch-chroot "$mountpoint" systemctl enable systemd-networkd.service
  arch-chroot "$mountpoint" systemctl enable systemd-resolved.service
  arch-chroot "$mountpoint" systemctl enable wpa_supplicant@wlan0.service
  ln -sf /run/systemd/resolve/resolv.conf /mnt/etc/resolv.conf
}

generate_locales(){
  arch-chroot "$mountpoint" locale-gen
  if [ $? -eq 0 ]; then
    msg "Locales is good";
  else
    die "Locales is bad";
  fi
}

mount_efivars(){
  mount -o remount /sys/firmware/efi/efivars -o rw,nosuid,nodev,noexec,noatime
  if [ $? -eq 0 ]; then
    msg "Efivars is good";
  else
    die "Efivars is bad";
  fi
  arch-chroot "$mountpoint" mount -o remount /sys/firmware/efi/efivars -o rw,nosuid,nodev,noexec,noatime
}

generate_fstab(){
  genfstab -U -p "$mountpoint" >> "$mountpoint/etc/fstab"
  if [ $? -eq 0 ]; then
    msg "Fstab is good";
  else
    die "Fstab is bad";
  fi
}

check_permissions(){
arch-chroot "$mountpoint" chown -c root:root /etc/sudoers.d/10_custom
arch-chroot "$mountpoint" chmod -c 0440 /etc/sudoers.d/10_custom
}

update_pkgfile(){
arch-chroot "$mountpoint" pkgfile --update
}

chsh_root(){
  arch-chroot "$mountpoint" chsh --shell=/bin/zsh root
  arch-chroot "$mountpoint" cp /etc/skel/.zshrc ~/
}

enable_firstboot(){
  arch-chroot "$mountpoint" rm --verbose  -rf /etc/{machine-id,localtime,hostname,shadow,locale.conf}
  arch-chroot "$mountpoint" systemctl enable systemd-firstboot.service
}

setup_systemd_in_chroot(){
  local name="generating locales, rollback layout, enabling needed services"
  title "Start $name: $@"
  generate_locales
  setup_rollback_layout
#  setup_pacman
  enable_network_services
  check_permissions
# mount_efivars
  generate_fstab
  update_pkgfile
  chsh_root
  arch-chroot "$mountpoint" mkinitcpio -p linux
  arch-chroot "$mountpoint" bootctl install
  enable_firstboot
}

export setup_systemd_in_chroot
