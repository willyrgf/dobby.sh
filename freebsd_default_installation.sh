#!/bin/sh

set -x

_set_env_vars() {
    export \
        INSTALLER="/usr/sbin/pkg"
        INSTALLER_INSTALL_PARAM="install -y"
}

_set_packages() {
    export \
        PACKAGES='vim git zabbix4-agent'
}

_install_packages() {
    for p in ${PACKAGES}; do
        ${INSTALLER} ${INSTALLER_INSTALL_PARAM} ${p}
    done
}

_main() {
    _set_env_vars
    _set_packages

    _install_packages
}

_main $@
