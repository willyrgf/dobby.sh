#!/bin/sh

set -x

os_namespace=$(uname | tr 'A-Z' 'a-z') || exit 1

if [ ${os_namespace} == "" ]; then
    exit 1
fi

_set_main_envs() {
    export \
        RUN_UPGRADE=true
}

_main() {
    _${os_namespace}_zabbix_agent_main
}

_main $@
