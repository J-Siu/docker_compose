#!/bin/sh

GIT_DIR=/hugo
PUB_DIR=/public

echo GIT_URL:${GIT_URL}
echo GIT_DIR:${GIT_DIR}
echo GIT_SUB:${GIT_SUB}
echo PUB_DIR:${PUB_DIR}

ERR_CHK() {
	CMD=$1
	RTN=$2
	if [ ${RTN} -ne 0 ]; then
		echo \"$CMD\" error:${RTN}
		exit ${RTN}
	fi
}

echo P_TZ:${P_TZ}
if [ "${#P_TZ}" -gt "0" ]; then
	TZ="/usr/share/zoneinfo/${P_TZ}"
	if [ -f "${TZ}" ]; then
		cp ${TZ} /etc/localtime
		echo "${P_TZ}" >/etc/timezone
	fi
fi

# check PUB_DIR
if [ ! -d ${PUB_DIR} ]; then
	echo ${PUB_DIR} not available
	exit 1
fi

CMD="git clone ${GIT_URL} ${GIT_DIR}"
$CMD
ERR_CHK "${CMD}" $?

cd ${GIT_DIR}

# Pull sub-module
if [ "${#GIT_SUB}" -gt "0" ]; then
	CMD="git submodule update --init --recursive"
	echo $CMD
	$CMD
	ERR_CHK "${CMD}" $?
fi

CMD="hugo $@"
$CMD
ERR_CHK "${CMD}" $?

# Export to /public
cp -r public/* ${PUB_DIR}/
