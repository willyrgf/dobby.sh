#!/usr/bin/env bash

set -x

os_namespace=$(uname | tr 'A-Z' 'a-z') || exit 1

if [ ${os_namespace} == "" ]; then
    exit 1
fi

_set_main_envs() {
    export \
        RUN_UPGRADE=true
        SERVICES='zabbix_agent'
        NULL='/dev/null'
}

_main() {
    _set_main_envs

    for service in ${SERVICES}; do
        source ${os_namespace}/${service}_config_service.sh ||
            exit 1
        _${os_namespace}_${service}_main
    done
}

_main $@
