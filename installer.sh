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
    _set_main_envs
    . ${os_namespace}/default_installation.sh || exit 1
    _${os_namespace}_main $@

    . ${os_namespace}/basic_environment_install.sh || exit 1
    _${os_namespace}_main $@
}

_main $@
