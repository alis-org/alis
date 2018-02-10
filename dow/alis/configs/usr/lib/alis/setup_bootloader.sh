#!/usr/bin/bash
#
# DESCRIPTION
#

generate_keys(){
    cd /etc/sbp
    read -p "Enter a Common Name: " NAME
    echo "$NAME" > NAME

    openssl req -new -x509 -newkey rsa:2048 -subj "/CN=$NAME PK/" -keyout PK.key \
                -out PK.crt -days 3650 -nodes -sha256
    openssl req -new -x509 -newkey rsa:2048 -subj "/CN=$NAME KEK/" -keyout KEK.key \
                -out KEK.crt -days 3650 -nodes -sha256
    openssl req -new -x509 -newkey rsa:2048 -subj "/CN=$NAME db/" -keyout db.key \
                -out db.crt -days 3650 -nodes -sha256

    openssl x509 -in PK.crt -out PK.cer -outform DER
    openssl x509 -in KEK.crt -out KEK.cer -outform DER
    openssl x509 -in db.crt -out db.cer -outform DER

    GUID="$(uuidgen --random)"
    echo "$GUID" > GUID

    cert-to-efi-sig-list -g $GUID PK.crt PK.esl
    cert-to-efi-sig-list -g $GUID KEK.crt KEK.esl
    cert-to-efi-sig-list -g $GUID db.crt db.esl

    echo -n > PK_null.esl

    sign-efi-sig-list -k PK.key -c PK.crt PK PK.esl PK.auth
    sign-efi-sig-list -k PK.key -c PK.crt PK PK_null.esl PK_null.auth

    chmod 0400 *.{key,auth}
    sync

    msg "New UEFI Secure Boot keys created in '$EFI_KEYS_DIR'"
}

enroll_keys(){
    cd /etc/sbp

    if ! [[ -f KEK.esl ]] || ! [[ -f db.esl  ]] || ! [[ -f PK.auth  ]]; then
        die "Missing keys"
    fi

    msg "Enrolling UEFI Secure Boot KEK key..."
    efi-updatevar -e -f KEK.esl KEK

    msg "Enrolling UEFI Secure Boot db key..."
    efi-updatevar -e -f db.esl db

    msg "Enrolling UEFI Secure Boot PK key..."
    efi-updatevar -f PK.auth PK

    msg "UEFI Secure Boot keys in '$EFI_KEYS_DIR' enrolled to UEFI firmware."
}

create_efi_entety(){
  sbpctl standalone --osrel="/etc/os-release" --initrd="/boot/intel-ucode.img" --initrd="/boot/initramfs-linux.img"  --cmdline="root=/dev/mapper/arch init=/usr/lib/systemd/systemd rw quiet" --sign /boot/EFI/BOOT
  if [ $? -eq 0 ]; then
    msg "EFI loader is good";
  else
    die "EFI loader is bad";
  fi
}

setup_bootloader(){
  local name="generating efi app, signing and place it to ESP"
  title "Start $name: $@"
  generate_keys
  enroll_keys
  create_efi_entety
  setup_secure_boot
}

export setup_bootloader