#!/bin/sh

# general variables
NAME="dobby.sh"
NULL='/dev/null'
PID_FILE="/var/run/${NAME}.pid"
WORKDIR="$(dirname "$0")" || exit 1

# args variables
COMMANDS_DIR="commands"

_help() {
    echo "
usage: $0 <command>

http://github.com/willyrgf/dobby.sh
A cli tool to help the system administration of Freebsd and Linux servers.
"
    exit 255
}

_err() {
  echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')]: $*" >&2
}

_check_pidfile() {
  [ -f ${PID_FILE} ] && return 1 || return 0
}

_create_pidfile() {
  _check_pidfile || exit 1
  echo $$ > "${PID_FILE}"
}

_remove_pidfile() {
  rm -f "${PID_FILE}"
}

_get_file_of_commands_available() {
    ls -1 -f "${WORKDIR}"/"${COMMANDS_DIR}"/*.sh  2> ${NULL}
}

_get_file_of_a_command() {
    ls -1 -f "${WORKDIR}"/"${COMMANDS_DIR}"/"$1".sh  2> ${NULL}
}

_get_commands_available() {
    for f in $(_get_file_of_commands_available); do
        basename "${f}" | cut -f1 -d'.' 2> ${NULL}
    done
}

_is_a_command() {
    [ -n "$1" ] || return 1
    for c in $(_get_commands_available); do
        if [ "${c}" = "$1" ]; then
            echo "${c}"
            return 0
        fi
    done
    _err "command  not recognized: $1"
    return 1
}

_exec_command() {
    file_cmd=$(_get_file_of_a_command "$1") || return 1

    ${file_cmd} "$@"
}

[ "${#@}" -ge 1 ] || _help

_main() {
  # if doesn't exist pidfile, create
  _create_pidfile || exit 1

  command=$(_is_a_command "$1") || _help
  shift

  _exec_command "${command}" "$@" || exit 1

  # finish the app
  _remove_pidfile
}

_main "$1" "$@" || exit $?
