#!/bin/sh

set -x 

_freebsd_pre_reqs() {
    command -v git || exit 1
    command -v vim || exit 1
}

_freebsd_set_env_vars() {
    export \
        GIT=$(command -v git)
        BASH=$(command -v bash)
}

_freebsd_install_csh_configs() {
    ${GIT} https://github.com/willyrgf/freebsd-configs /tmp/freebsd-configs|| exit 1
    cat /tmp/freebsd-configs/cshrc > ~/.cshrc
}

_freebsd_install_vim_configs() {
    ${GIT} https://github.com/willyrgf/vimfiles /tmp/vimfiles || exit 1
    cd /tmp/vimfiles
    ./install_vimrc.sh
}

_freebsd_main() {
    _freebsd_pre_reqs
    _freebsd_install_csh_configs
    _freebsd_install_vim_configs
}
