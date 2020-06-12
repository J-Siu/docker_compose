#!/bin/sh

[ -z ${MY_GIT_DIR} ] && MY_GIT_DIR=/hugo

echo MY_TZ:${MY_TZ}
echo MY_GIT_DIR:${MY_GIT_DIR}
echo MY_GIT_URL:${MY_GIT_URL}
echo MY_GIT_SUB:${MY_GIT_SUB}
echo MY_PUB_DIR:${MY_PUB_DIR}
echo GIT_SSL_NO_VERIFY:${GIT_SSL_NO_VERIFY}

# Run cmd with error check
RUN_CMD() {
	CMD=$1
	$CMD
	RTN=$?
	if [ ${RTN} -ne 0 ]; then
		echo \"$CMD\" error:${RTN}
		exit ${RTN}
	fi
	return ${RTN}
}

# --- TZ
if [ "${#MY_TZ}" -gt "0" ]; then
	TZ="/usr/share/zoneinfo/${MY_TZ}"
	if [ -f "${TZ}" ]; then
		cp ${TZ} /etc/localtime
		echo "${MY_TZ}" >/etc/timezone
	fi
fi

# --- MY_PUB_DIR check
[ ! -z ${MY_PUB_DIR} ] && [ ! -d ${MY_PUB_DIR} ] && RUN_CMD "mkdir -p ${MY_PUB_DIR}"

# --- GIT Clone/Pull
if [ ! -d ${MY_GIT_DIR} ]; then
	# MY_GIT_DIR does not exist, do git clone
	RUN_CMD "git clone ${MY_GIT_URL} ${MY_GIT_DIR}"
else
	# MY_GIT_DIR exist ...
	echo ${MY_GIT_DIR} exist ...
	if [ "$(ls -A ${MY_GIT_DIR})" ]; then
		{
			echo ... not empty
			if [ -d ${MY_GIT_DIR}/.git ]; then
				echo ... is repo
				RUN_CMD "cd ${MY_GIT_DIR}"
				# Check if remote same as MY_GIT_URL
				REMOTE=$(git remote -v | grep \(fetch\))
				case "${REMOTE}" in
				*"${MY_GIT_URL}"*)
					echo ... pull
					RUN_CMD "git pull"
					;;
				*)
					echo MY_GIT_URL:${MY_GIT_URL} not same as repo remote: ${REMOTE}
					exit 1
					;;
				esac
			else
				echo ... not repo, don\'t touch, exit
				echo ${MY_GIT_DIR} exist but not empty and not a git repo.
				exit 1
			fi
		}
	else
		{
			# MY_GIT_DIR exist but empty
			echo ... empty
			RUN_CMD "git clone ${MY_GIT_URL} ${MY_GIT_DIR}"
		}
	fi
fi

# --- GIT Sub-module
if [ ! -z ${MY_GIT_SUB} ]; then
	RUN_CMD "cd ${MY_GIT_DIR}"
	RUN_CMD "git submodule update --init --recursive"
fi

# --- Hugo
RUN_CMD "hugo $@"

# --- Copy
[ ! -z ${MY_PUB_DIR} ] && RUN_CMD "cp -r public/* ${MY_PUB_DIR}/"
