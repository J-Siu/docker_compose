source auto.common.sh

# Dockerfile array hold following:
# FROM {from}
# LABEL version="{version}"
# LABEL maintainers="{maintainers}"
# LABEL name="{name}"
# LABEL usage="{usage}"
# {distro} derived from {from}
# {tag} derived from {from}
# {project} project/dir name
declare -A dockerfile

# List of distro::branch
distro_tags=''

distro_branch_update() {
	for _i in ${auto_distro_root}/*; do
		source ${_i}/${auto_db_conf}
		for _j in ${tags}; do
			distro_tags+=" ${my_distro_name}:${_j}"
		done
	done
}

# ${1} project path
dockerfile_get() {
	local _project_path=${1}
	local _project=$(basename ${__project_path})
	local _dockerfile_path=${_project_path}/Dockerfile
	for _i in version maintainers name usage; do
		local _val=$(grep "^LABEL\ ${_i}" ${_dockerfile_path} | cut -d= -f2-)
		_val=${_val##\"} # strip first "
		_val=${_val%%\"} # strip last "
		dockerfile[${_i}]=${_val}
		echo ${_i}:"${dockerfile[${_i}]}"
	done
	dockerfile["from"]=$(grep "^FROM\ " ${_dockerfile_path} | cut -d' ' -f2-)
	echo from:"${dockerfile['from']}"
	dockerfile['distro']=${dockerfile['from']%:*}
	echo distro:"${dockerfile['distro']}"
	dockerfile['tag']=${dockerfile['from']#*:}
	echo tag:"${dockerfile['tag']}"
	dockerfile['project']=${_project}
	echo project:"${dockerfile['project']}"
}

dockerfile_skip() {
	local _distro=${dockerfile["distro"]}
	local _from="${dockerfile["from"],,}" # change to lowercase
	local _pkg=${dockerfile["name"]}
	local _tag=${dockerfile["tag"]}
	local _ver=${dockerfile["version"]}

	#echo ${_from}, ${_tag}, ${_pkg}

	[[ ${_from} == *" as "* ]] && echo "Has AS" && return 0                                  # 0=true, skip, not simple
	[[ ${distro_tags} != *"${_distro}:${_tag}"* ]] && echo "distro:tag no match" && return 0 # 0=true, skip, not edge/latest

	local _db_pkg_ver=$(auto_db_pkg_ver ${_distro} ${_tag} ${_pkg})
	[[ -z ${_db_pkg_ver} ]] && echo "PKG not found" && return 0                # 0=true, skip, pkg not found
	[[ "${_ver}" == "${_db_pkg_ver}" ]] && echo "PKG no update" && return 0    # 0=true, skip, same version
	[[ "${_ver}" > "${_db_pkg_ver}" ]] && echo "PKG newer than db" && return 0 # 0=true, skip, doesn't make sense, oh well ...

	return 1 # 1=false, don't skip
}

# ${1} staging dir
# ${2} pkg
dockerfile_build() {
	local _dir=${1}
	local _pkg=${2}
	local _img="${_pkg}:${auto_stg_tag}"
	local _curr_dir=$(pwd)
	cd ${_dir}
	docker build --quiet -t ${_img} .
	local _rtn=$?
	# clean up
	docker image rm ${_img}
	cd ${_curr_dir}
	return ${_rtn}
}

# ${1} staging dir
dockerfile_update() {
	local _dir=${1}
	local _p
	local _file=${_dir}/Dockerfile
	local _old_ver=${dockerfile["version"]}
	local _new_ver=$(auto_db_pkg_ver ${dockerfile["distro"]} ${dockerfile["tag"]} ${dockerfile["name"]})
	echo ${_old_ver} '->' ${_new_ver}
	sed -i "s/${_old_ver}/${_new_ver}/g" ${_file}

	# maintainers
	sed -i "s/^LABEL maintainers=*/LABEL maintainers=\"${auto_git_maintainers}\"/g" ${_file}

	# usage
	local _usage="${auto_git_maintainers}/${dockerfile["project"]}/blob/master/README.md"
	sed -i "s/^LABEL usage=*/LABEL usage=\"${_usage}\"/g" ${_file}
}

# ${1} staging dir
license_update() {
	local _file=${1}/LICENSE
	cp LICENSE ${_file}
	# Update copyright year
	local _year=$(date +%Y)
	sed -i "s/^Copyright (c).*/Copyright (c) ${_year}/g" ${_file}
}

# ${1} staging dir
readme_update() {
	local _file=${1}/README.md
	local _new_ver=$(auto_db_pkg_ver ${dockerfile["distro"]} ${dockerfile["tag"]} ${dockerfile["name"]})

	# Update Change Log before line <!--CHANGE-LOG-END-->
	local _log="- ${_new_ver}"
	sed -i "s/${auto_log_end}/${_log}\n${auto_log_end}/g" ${_file}
	local _log="  - Auto update to ${_new_ver}"
	sed -i "s/${auto_log_end}/${_log}\n${auto_log_end}/g" ${_file}

	# Update copyright year
	local _year=$(date +%Y)
	sed -i "s/^Copyright (c).*/Copyright (c) ${_year}/g" ${_file}
}

# ${1} project dir
project_update() {
	local _project=${1}

	# clear global var dockerfile
	for _j in from version maintainers name usage; do
		dockerfile[${_j}]=''
	done

	if [ -f ${_project}/Dockerfile ]; then
		dockerfile_get ${_project}

		# dockerfile_skip use global var dockerfile
		if dockerfile_skip; then
			echo skipping ${_project}
		else
			echo processing ${_project}
			# Staging dir
			local _dir_stg=${auto_stg_root}/${dockerfile["name"]}
			# Delete if staging dir exist
			[ -d ${_dir_stg} ] && rm -rf ${_dir_stg}
			# Copy project to staging
			cp -r ${_project} ${auto_stg_root}/
			# Update Dockerfile
			dockerfile_update ${_dir_stg}
			# Build
			dockerfile_build ${_dir_stg} ${dockerfile["name"]}
			local _rtn=$?
			# If build successful
			if [ ${_rtn} -eq 0 ]; then
				readme_update ${_dir_stg}
				license_update ${_dir_stg}
				# Copy from staging to project
				for _j in Dockerfile README.md LICENSE; do
					CMD="cp ${_dir_stg}/${_j} ${_project}/"
					echo $CMD
					$CMD
					# Add to file change list
					file_changed+=" ${_project}/${_j}"
				done

				# Add git msg
				local _old_ver=${dockerfile["version"]}
				local _new_ver=$(auto_db_pkg_ver ${dockerfile["distro"]} ${dockerfile["tag"]} ${dockerfile["name"]})
				git_msg+="\n- ${dockerfile["name"]} ${_old_ver} -> ${_new_ver}"
			fi
		fi
	fi
}

# --- Main ---

# Load pkg db
auto_db_read

[ ! -d ${auto_stg_root} ] && mkdir -p ${auto_stg_root}

distro_branch_update

echo ${distro_branch}

for _docker in ${auto_project_prefix}*; do
	echo ---
	echo ${_docker}
	project_update ${_docker}
done
