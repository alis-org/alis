#!/usr/bin/bash
#
# DESCRIPTION
# https://goo.gl/FoKRZk
create_os_part(){
  truncate -s 2M "$luks_header"
  if [ $? -eq 0 ]; then
    msg "Creating $luks_header is good";
  else
    die "Creating $luks_header is bad";
  fi

  cryptsetup -q -c "$cipher" luksFormat "$os_part"  --type=luks2 --disable-keyring -y --progress-frequency=1 -t=100 -T=2  --header="$luks_header"  --uuid="$luks_uuid" --label="$os_label"
  if [ $? -eq 0 ]; then
    msg "Formating $os_part to luks device is good";
  else
    die "Formating $os_part to luks device is bad";
  fi

  cryptsetup -q luksOpen "$os_part" --header="$luks_header" "$luks_device"
  if [ $? -eq 0 ]; then
    msg "Opening $os_part as $luks_device is good";
  else
    die "Opening $os_part as $luks_device is bad";
  fi

  mkfs.btrfs -f -q --uuid "$os_uuid"  --label "$os_label" "/dev/mapper/$luks_device"
  sleep 5
  if [ $? -eq 0 ]; then
    msg "Creating btrfs on /dev/mapper/$luks_device with UUID=$os_uuid and LABEL=$os_label is good";
  else
    die "Creating btrfs on /dev/mapper/$luks_device with UUID=$os_uuid and LABEL=$os_label is bad";
  fi

  mount -o "$os_part_opts"  "/dev/mapper/$luks_device" "$mountpoint"
             mkdir -v -p "$mountpoint/archlinux"
             mkdir -v -p "$mountpoint/archlinux/var"
             mkdir -v -p "$mountpoint/archlinux/usr"
  btrfs subvolume create "$mountpoint/archlinux/root"
  btrfs subvolume create "$mountpoint/archlinux/home"
  btrfs subvolume create "$mountpoint/archlinux/srv"
  btrfs subvolume create "$mountpoint/archlinux/opt"
  btrfs subvolume create "$mountpoint/archlinux/usr/local"
  btrfs subvolume create "$mountpoint/archlinux/var/tmp"
  btrfs subvolume create "$mountpoint/archlinux/var/opt"
  btrfs subvolume create "$mountpoint/archlinux/var/log"
  btrfs subvolume create "$mountpoint/archlinux/var/cache"

             mkdir -v -p "$mountpoint/snapshots"
             mkdir -v -p "$mountpoint/snapshots/var"
             mkdir -v -p "$mountpoint/snapshots/usr"
  btrfs subvolume create "$mountpoint/snapshots/snapper_root"
  btrfs subvolume create "$mountpoint/snapshots/snapper_home"
  btrfs subvolume create "$mountpoint/snapshots/snapper_srv"
  btrfs subvolume create "$mountpoint/snapshots/snapper_opt"
  btrfs subvolume create "$mountpoint/snapshots/usr/snapper_local"
  btrfs subvolume create "$mountpoint/snapshots/var/snapper_tmp"
  btrfs subvolume create "$mountpoint/snapshots/var/snapper_opt"
  btrfs subvolume create "$mountpoint/snapshots/var/snapper_log"
  btrfs subvolume create "$mountpoint/snapshots/var/snapper_cache"

  if [ $? -eq 0 ]; then
    msg "Creating btrfs layout is good";
  else
    die "Creating btrfs layout is bad";
  fi

  sleep 5
  umount -R "$mountpoint"
  mount -t btrfs -o subvol=/archlinux/root,"$os_part_opts" "/dev/mapper/$luks_device"  "$mountpoint"
  mkdir -p "$mountpoint/boot"
  mkdir -p "$mountpoint/home"
  mkdir -p "$mountpoint/srv"
  mkdir -p "$mountpoint/opt"
  mkdir -p "$mountpoint/tmp"
  mkdir -p "$mountpoint/usr/local"
  mkdir -p "$mountpoint/var/tmp"
  mkdir -p "$mountpoint/var/opt"
  mkdir -p "$mountpoint/var/log"
  mkdir -p "$mountpoint/var/cache"

  mount -t btrfs -o subvol=/archlinux/home,"$os_part_opts"           "/dev/mapper/$luks_device"     "$mountpoint/home"
  mount -t btrfs -o subvol=/archlinux/srv,"$os_part_opts"            "/dev/mapper/$luks_device"     "$mountpoint/srv"
  mount -t btrfs -o subvol=/archlinux/opt,"$os_part_opts"            "/dev/mapper/$luks_device"     "$mountpoint/opt"
  mount -t btrfs -o subvol=/archlinux/usr/local,"$os_part_opts"      "/dev/mapper/$luks_device"     "$mountpoint/usr/local"
  mount -t btrfs -o subvol=/archlinux/var/tmp,"$os_part_opts"        "/dev/mapper/$luks_device"     "$mountpoint/var/tmp"
  mount -t btrfs -o subvol=/archlinux/var/opt,"$os_part_opts"        "/dev/mapper/$luks_device"     "$mountpoint/var/opt"
  mount -t btrfs -o subvol=/archlinux/var/log,"$os_part_opts"        "/dev/mapper/$luks_device"     "$mountpoint/var/log"
  mount -t btrfs -o subvol=/archlinux/var/cache,"$os_part_opts"      "/dev/mapper/$luks_device"     "$mountpoint/var/cache"
  chmod 1777 "$mountpoint/var/tmp"

  ##TODO: move to separate functions
  mount -t vfat -o "$esp_part_opts"                                  "$esp_part"        "$mountpoint/boot"
  mv "$luks_header" "$mountpoint/boot"


  if [ $? -eq 0 ]; then
    msg "Mouting layout is good";
  else
    die "Mounting layout layout is bad";
  fi
}

create_esp_part(){
  mkfs.vfat -c -n "$esp_label" -F32 "$esp_part" > log
  if [ $? -eq 0 ]; then
    msg "Formating $esp_part to fat32 partition is good";
  else
    die "Formating $esp_part to fat32 partition is bad";
  fi
}

append_parts_table(){
  sfdisk -q /dev/sda < libs/entire-ESP-OS.dump > log
  if [ $? -eq 0 ]; then
    msg "New partition table on /dev/sda is good";
  else
    die "New partition table on /dev/sda is bad";
  fi
}

wipe_fs(){
  wipefs --quiet --all /dev/sda > log
  if [ $? -eq 0 ]; then
    msg "Wipe partition table on /dev/sda is good";
  else
    die "Wipe partition table on /dev/sda is bad";
  fi
}

create_partitions(){
  local name="create partitions script"
  title "Start $name: $@"
  wipe_fs
  append_parts_table
  create_esp_part
  create_os_part
}

export create_partitions