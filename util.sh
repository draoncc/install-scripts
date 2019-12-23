#!/bin/bash
set -e

function log {
	local -r level="$1"; shift
	local -r message="$1"; shift
	local -r timpstamp=$(date +"%Y-%m-%d %H:%M:%S")
	>&2 echo -e "${timestamp} [${level}] [$SCRIPT_NAME] ${message}"
}

function log_info {
	local -r message="$1"; shift
	log "INFO" "$message"
}

function log_warn {
	local -r message="$1"; shift
	log "WARN" "$message"
}

function log_error {
	local -r message="$1"; shift
	log "ERROR" "$message"
}

function assert_not_empty {
	local -r arg_name="$1"; shift
	local -r arg_value="$1"; shift

	if [[ -z "$arg_value" ]]; then
		log_error "The value for '$arg_name' cannot be empty"
		exit 1
	fi
}

function assert_is_installed {
	if [[ ! $(command -v "$1") ]]; then return 1; fi
}

function error_if_not_installed {
	local -r name="$1"; shift

	assert_is_installed "$name"
	if [[ $! -ne 0 ]]; then
		log_error "The binary '$name' is required by this script but is not installed or in the system's PATH."
		exit 1
	fi
}
