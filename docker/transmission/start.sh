#!/bin/sh

PROG=/usr/bin/transmission-daemon
PUSR=transmission
PHOME=/${PUSR}

echo PUID:${PUID}
if [ "${PUID}" -lt "1000" ]
then
	echo PUID cannot be \< 1000
	exit
fi

echo PGID:${PGID}
if [ "${PGID}" -lt "1000" ]
then
	echo PGID cannot be \< 1000
	exit
fi

echo P_TZ:${P_TZ}
if [ "${#P_TZ}" -gt "0" ]
then
	TZ="/usr/share/zoneinfo/${P_TZ}"
	if [ -f "${TZ}" ]
	then
		cp ${TZ} /etc/localtime
		echo "${P_TZ}" > /etc/timezone
	fi
fi

deluser ${PUSR}
delgroup ${PUSR}

addgroup -g ${PGID} ${PUSR}
adduser -D -h ${PHOME} -G ${PUSR} -u ${PUID} ${PUSR}
chown -R ${PUSR}:${PUSR} ${PHOME}

su - ${PUSR} -c "${PROG} \"-f\""