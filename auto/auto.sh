#!/bin/bash

COMMON="auto.common.sh"
source ${COMMON}

# --- main

pid=${BASHPID}

# - Create Staging Area
timestamp=$(date +%Y-%m-%d-%H:%M:%S:%N)
# dir_stg=${dir_tmp}/${timestamp}-${pid}
dir_stg_root=${dir_tmp}/testing
mkdir -p ${dir_stg_root}

auto_db_update

auto_docker_update