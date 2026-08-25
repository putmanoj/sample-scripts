#!/bin/bash

vcsim_api_version="8.0"
volume_name=tmp-vcsim-data
container_vcsim_data_dir=/data/vcsim
volume_mapping=${volume_name}:${container_vcsim_data_dir}:z

host_vcsim_data_dir=$(pwd)/vcsim-data

function run_govc() {
	local govc_cmd=$@
	local govc_url="${GOVC_URL:-https://user:pass@localhost:4443/sdk}"
	docker run --rm --network host \
		-e GOVC_URL="${govc_url}" \
		-e GOVC_INSECURE=true \
		-e GOVC_VIM_VERSION="${vcsim_api_version}" \
		-v ${volume_mapping} \
		vmware/govc:latest /govc ${govc_cmd}
}

function run_cmd_in_container() {
	local cmd="$@"
	docker run --rm \
		-v ${volume_mapping} \
		-v ${host_vcsim_data_dir}:/dest \
		alpine sh -c "${cmd}"
}

function cp_vcsim_data() {
	echo "* Copy vcsim data"
	local state_dir=${1:-current-state}

	rm -rf "${host_vcsim_data_dir}/${state_dir}"
	run_cmd_in_container "rm -rf ${container_vcsim_data_dir}/${state_dir}"
	GOVC_URL=${GOVC_URL} run_govc object.save -d "${container_vcsim_data_dir}/${state_dir}"
	run_cmd_in_container "cp -R ${container_vcsim_data_dir}/${state_dir} /dest/"
	du -sh ${host_vcsim_data_dir}/${state_dir}
}

function setup() {
	if ! docker volume inspect ${volume_name} >/dev/null 2>&1; then
		echo "Volume missing. Creating..."
		docker volume create ${volume_name}
	else
		echo "Volume ${volume_name} already exists."
	fi
	mkdir -p ${host_vcsim_data_dir}
}

function cleanup() {
	echo "* Cleanup tmp-vcsim,volume"
	docker rm -f tmp-vcsim
	docker volume rm -f ${volume_name}
}

function tmp_vcsim_start() {
	echo "* Start new vcsim"
	docker run --rm -d --name tmp-vcsim \
		-p 9989:8989 \
		vmware/vcsim:latest \
		-l :8989 -api-version "${vcsim_api_version}"
	sleep 2s
	docker logs tmp-vcsim
}

# Persist base vcsim-data, for vcsim-service startup
function create-base-vcsim-data() {
	cleanup
	setup
	tmp_vcsim_start
	GOVC_URL=https://user:pass@localhost:9989/sdk run_govc about
	GOVC_URL=https://user:pass@localhost:9989/sdk cp_vcsim_data base-state
	cleanup
}

# Create server certs for vcsim-service
function certs() {
	mkdir $(pwd)/certs && \
	openssl req -x509 -newkey rsa:2048 -nodes \
		-keyout ./certs/server.key \
		-out ./certs/server.crt \
		-days 365 -subj "/CN=127.0.0.1" \
		-addext "subjectAltName = IP:127.0.0.1"
}

# Persist current data from vcsim-service
function save-vcsim-data() {
	setup
	local SERVICE_NAME=vcsim-service

	if [ -z "$(docker compose ps --status=running -q $SERVICE_NAME)" ]; then
		echo "Service $SERVICE_NAME is NOT running."
		# exit 1
		exit 0
	else
		run_govc about
	fi

	cp_vcsim_data "saved-state"
	cleanup
}

# Start(in non-detached mode) -> Stop 
function run1() {
	docker compose up --force-recreate --remove-orphans
	docker compose down
}

# Start(in detached mode) -> Show logs -> Save(current vcsim state) on Ctrl+C -> Stop 
function run2() {
	echo -e "\n[Start] services"
	docker compose up -d --remove-orphans
	sleep 3s

	# 1. Trap Ctrl+C (SIGINT) so the script stays alive when Docker is stopped
	trap 'true' SIGINT

	echo "Streaming logs. Press Ctrl+C to stop and trigger Command 2..."
	echo "------------------------------------------------------------------------"

	# 2. Run docker logs directly to the terminal
	docker compose logs -f
	local EXIT_CODE=$?

	# 3. Reset the trap back to default behavior
	trap - SIGINT

	# 4. Check if Docker was explicitly stopped by Ctrl+C (Exit code 130)
	if [ $EXIT_CODE -eq 130 ]; then
		echo -e "\n\n[Ctrl+C Detected] Log stream stopped."
		
		# --- Save current state ---
		echo -e "\n[Save] current vcsim state ..."
		save-vcsim-data
		
	elif [ $EXIT_CODE -ne 0 ]; then
		echo -e "\n[Error] Docker logs failed or service stopped (Exit code: $EXIT_CODE)."
		echo "Docker logs will NOT run."
	else
		echo -e "\nDocker logs finished streaming cleanly on its own."
	fi

	echo -e "\n[Stop] services"
	docker compose down
} 

DEFAULT_FUNC=save-vcsim-data

if [ ! -z "$1" ];
then
	# Check if the function exists
	if declare -f "$1" > /dev/null
	then
		# call arguments verbatim
		"$@"
	else
		echo "Error: '$1' is not a known function name" >&2
		echo ""
		exit 1
	fi
else
	# run default function, if not function name passed
	${DEFAULT_FUNC}
fi

