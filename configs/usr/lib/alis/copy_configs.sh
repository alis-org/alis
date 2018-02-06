#!/usr/bin/bash
#
# DESCRIPTION
#
cp_cfgs(){
  cd configs;
  cp --backup=simple --suffix=".bakup" --parent  -P -R  -v  *  -t /mnt

  if [ $? -eq 0 ]; then
    msg "Coping config files is good";
  else
    die "Coping config files is bad";
  fi
  cd ..
}

copy_configs(){
  local name="coping config files to new system"
  title "Start $name: $@"
  cp_cfgs
 }