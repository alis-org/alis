#!/bin/bash
#
# Copyright (c) 2013 SUSE
#
# Written by Matthias G. Eckermann <mge@suse.com>
#
# Run this shell script to create a USER
#
# GLOBAL Settings
#

CMD_BTRFS="/sbin/btrfs"
CMD_SNAPPER="/usr/bin/snapper"
CMD_EGREP="grep -E"
CMD_PAM_CONFIG="/usr/sbin/pam-config"
CMD_SED="sed"
CMD_USERADD="/usr/bin/useradd"
CMD_USERDEL="userdel -r"
CMD_CHOWN="chown -R"
CMD_CHMOD="chmod -R"
#
SNAPPERCFGDIR="/etc/snapper/configs"
HOMEHOME="/home"
DRYRUN=0
#MYUSER=${new_user}
#MYGROUP=${new_user_group}
#if [ ".${MYGROUP}" == "." ] ; then MYGROUP="${MYUSER}"; fi
#
# Usage
#if [ "0$MYUSER" == "0" ]; then
#	echo "USAGE: $0 <username> [group]"
#	exit 1
#fi

# Sanity-Check: ist $HOMEHOME a btrfs filesystem
${CMD_BTRFS} filesystem df ${HOMEHOME} 2>&1 > /dev/null
RETVAL=$?
if [ ${RETVAL} != 0 ]; then
	echo "ERROR $0: ${HOMEHOME} is not on btrfs. Exiting ..."
	exit 2
fi

if [ ${DRYRUN} == 0 ] ; then
	# Create subvolume for USER
        ${CMD_BTRFS} subvol create ${HOMEHOME}/${new_user}
	# Create snapper config for USER
	${CMD_SNAPPER} -c home_${new_user} create-config ${HOMEHOME}/${new_user}
	 ${CMD_SED} -i -e "s/ALLOW_USERS=\"\"/ALLOW_USERS=\"${new_user}\"/g" ${SNAPPERCFGDIR}/home_${new_user}
	# Create USER
	 "${CMD_USERADD} ${new_user}"
	# yast users add username=${MYUSER} home=/home/${MYUSER} password=""
	# !! IMPORTANT !!
	# chown USER's home directory
	cp -R /etc/skel/.config  ${HOMEHOME}${new_user}
	${CMD_CHOWN} ${new_user}.${new_user_group} ${HOMEHOME}/${new_user}
	${CMD_CHMOD} 755 ${HOMEHOME}/${new_user}/.snapshots
else
	echo -e "#"
	echo "DRYRUN - no changes submitted"
fi
