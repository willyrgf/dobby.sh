#!/bin/sh

set -x

NAMESPACE="freebsd"

_freebsd_set_env_vars() {
    export \
        INSTALLER="/usr/sbin/pkg"
        INSTALLER_INSTALL_PARAM="install -y"
        INSTALLER_UPDATE="update"
        UPGRADER="/usr/sbin/freebsd-update"
        UPGRADER_PARAM="fetch install"
}

_freebsd_set_packages() {
    export \
        PACKAGES='vim git zabbix4-agent bash ctags
            tcpdump iftop lsof bind-tools wget sudo
            ntpdate'
}

_freebsd_install_packages() {
    ${INSTALLER} ${INSTALLER_UPDATE} &&
        for p in ${PACKAGES}; do
            ${INSTALLER} ${INSTALLER_INSTALL_PARAM} ${p}
        done
}

_freebsd_upgrade() {
    if [ ${RUN_UPGRADE} != true ]; then
        return
    fi

    ${UPGRADER} ${UPGRADER_PARAM}
}

_freebsd_main() {
    _freebsd_set_env_vars
    _freebsd_set_packages

    _freebsd_upgrade
    _freebsd_install_packages
}
