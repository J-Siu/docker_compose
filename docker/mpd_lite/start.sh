#!/bin/ash

PROG=/usr/bin/mpd
PUSR=mpd
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

deluser ${PUSR}
delgroup ${PUSR}

# detect and use host audio GID from /dev/snd/timer
AGID=$(stat -c %g /dev/snd/timer)
delgroup audio
addgroup -g ${AGID} audio

addgroup -g ${PGID} ${PUSR}
adduser -D -h ${PHOME} -G ${PUSR} -u ${PUID} ${PUSR}
adduser ${PUSR} audio
chown ${PUSR}:${PUSR} ${PHOME}

su - mpd -c "${PROG} \"--no-daemon\" \"/mpd.conf\""
# Debug
#su - mpd -c "${PROG} \"--stdout\" \"--no-daemon\" \"/mpd.conf\""