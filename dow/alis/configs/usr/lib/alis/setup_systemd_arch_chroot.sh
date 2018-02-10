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

  arch-chroot "$mountpoint"  mount -t btrfs -o subvol=/snapshots/snapper_root,"$os_part_optss"        "$/dev/mapper/luks_device"   /.snapshots
  arch-chroot "$mountpoint"  mount -t btrfs -o subvol=/snapshots/snapper_home,"$os_part_optss"        "$/dev/mapper/luks_device"   /home/.snapshots
  arch-chroot "$mountpoint"  mount -t btrfs -o subvol=/snapshots/snapper_srv,"$os_part_optss"         "$/dev/mapper/luks_device"   /srv/.snapshots
  arch-chroot "$mountpoint"  mount -t btrfs -o subvol=/snapshots/snapper_opt,"$os_part_optss"         "$/dev/mapper/luks_device"   /opt/.snapshots
  arch-chroot "$mountpoint"  mount -t btrfs -o subvol=/snapshots/usr/snapper_local,"$os_part_optss"   "$/dev/mapper/luks_device"   /usr/local/.snapshots
  arch-chroot "$mountpoint"  mount -t btrfs -o subvol=/snapshots/var/snapper_tmp,"$os_part_optss"     "$/dev/mapper/luks_device"   /var/tmp/.snapshots
  arch-chroot "$mountpoint"  mount -t btrfs -o subvol=/snapshots/var/snapper_opt,"$os_part_optss"     "$/dev/mapper/luks_device"   /var/opt/.snapshots
  arch-chroot "$mountpoint"  mount -t btrfs -o subvol=/snapshots/var/snapper_log,"$os_part_optss"     "$/dev/mapper/luks_device"   /var/log/.snapshots
  arch-chroot "$mountpoint"  mount -t btrfs -o subvol=/snapshots/var/snapper_cache,"$os_part_optss"   "$/dev/mapper/luks_device"   /var/cache/.snapshots

  arch-chroot "$mountpoint"  btrfs subvolume set-default 257 /
}

setup_systemd_in_chroot(){
  local name="configuring systemd for best user expirience"
  title "Start $name: $@"
  setup_rollback_layout
}

export setup_systemd_in_chroot