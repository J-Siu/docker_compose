#!/bin/sh

PROG=/usr/bin/amuled
PUSR=amule
PHOME=/${PUSR}

echo PUID:${PUID}
echo PGID:${PGID}

if [ "${PUID}" -lt "1000" ]
then
	echo PUID cannot be \< 1000
	exit
fi

if [ "${PGID}" -lt "1000" ]
then
	echo PGID cannot be \< 1000
	exit
fi

addgroup -g ${PGID} ${PUSR}
adduser -D -h ${PHOME} -G ${PUSR} -u ${PUID} ${PUSR}
chown -R ${PUSR}:${PUSR} ${PHOME}

su - ${PUSR} -c "${PROG} \"-o\""