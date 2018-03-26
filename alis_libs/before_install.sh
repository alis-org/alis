#!/usr/bin/bash
#
# DESCRIPTION
#
check_previous_install(){
  if [ -e "$luks_header" ]; then
    rm "$luks_header";
    msg "Previous header.img file now is good";
      else
        msg "Previous header.img is good";
  fi

  if mountpoint -q "$mountpoint"; then
    umount -R "$mountpoint";
    msg "Mount point now is good";
  else
    msg "Mount point is good";
  fi

  if [ -e "/dev/mapper/$luks_device" ]; then
    cryptsetup luksClose "$luks_device";
    msg "Luks device now is good";
  else
    msg "Luks device is good";
  fi
}

create_ranked_mirrorslist(){
  if [ -e "/etc/pacman.d/mirrorlist" ]; then
    cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup
  fi
  wget --quiet "https://www.archlinux.org/mirrorlist/?country=$country_code&protocol=https&ip_version=4" -O '/etc/pacman.d/mirrorlist.tmp'
  sed -i 's/^#Server/Server/' /etc/pacman.d/mirrorlist.tmp


  if rankmirrors -n 6 /etc/pacman.d/mirrorlist.tmp > /etc/pacman.d/mirrorlist; then
    msg "Mirrors list is good";
  else
    die "Mirrors list is bad";
  fi
}

sync_sys_time(){
  if timedatectl set-ntp true; then
    msg "Time is good";
  else
    die "Time is bad";
  fi
}

check_efi_folder(){
  if [ -d "/sys/firmware/efi/efivars" ]; then
    msg "EFI is good";
  else
    die "EFI is bad";
  fi
}

check_ping_result(){
  if ping -c 3 www.archlinux.org; then
    msg "Network is good";
  else
    die "Network is bad";
  fi
}

before_install(){
  check_ping_result
  check_efi_folder
  sync_sys_time
  create_ranked_mirrorslist
  check_previous_install
}

export before_install
