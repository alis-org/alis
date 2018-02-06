#!/usr/bin/bash
#
# DESCRIPTION
#
install_minimal_packages(){
  local name="installing minimal required packages"
  title "Start $name: $@"
  pacstrap  -C configs/pacstrap.conf "$mountpoint" "$min_packages"
}

export install_minimal_packages