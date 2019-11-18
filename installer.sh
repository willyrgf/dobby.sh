#!/bin/sh

os_namespace=$(uname | tr 'A-Z' 'a-z')

if [[ ! -n ${os} ]]; then
    exit 1
fi

_set_main_envs() {
    export \
        RUN_UPGRADE=true
}

_main() {
    source ${os_namespace}/default_installation.sh || exit 1
    _set_main_envs
    _${os_namespace}_main $@
}

_main $@
