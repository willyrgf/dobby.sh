#!/usr/bin/env bash

NAMESPACE="freebsd"
SERVICE="zabbix_agent"

zabbix_agent_user='zabbix'
zabbix_agent_group='zabbix'

zabbix_agent_conf_file='/usr/local/etc/zabbix4/zabbix_agentd.conf'

zabbix_agent_log_dir='/var/log/zabbix'
zabbix_agent_log_file='zabbix_agentd.log'

zabbix_agent_basic_conf="
"

_freebsd_zabbix_config_file(){
    if [ -f ${zabbix_agent_conf_file} ]; then
        cp ${zabbix_agent_conf_file} ${zabbix_agent_conf_file}.samples
    fi
    touch ${zabbix_agent_conf_file}

    [ -f "${zabbix_agent_conf_file}" ] &&
        echo ${zabbix_agent_conf_file} ||
        exit 1
}

_freebsd_zabbix_config_agent() {
    . config/${SERVICE}_config.sh &&
        _config_${SERVICE}_envs
    file="$(_freebsd_zabbix_config_file)"

    servers="$(echo ${ZABBIX_SERVERS} | tr ' ' ',')"
    hostname="${HOSTNAME}"

    if [[ ! -n ${servers} ]] || [[ ! -n ${hostname} ]]; then
        exit 1
    fi

    cat <<EOF > ${file}
LogFile=${zabbix_agent_log_dir}/${zabbix_agent_log_file}
Hostname=${hostname}
Server=${servers}
ServerActive=${servers}
EOF
}

_freebsd_setup_config() {
    mkdir -p ${zabbix_agent_log_dir}
    touch ${zabbix_agent_log_dir}/${zabbix_agent_log_file}
    chown -R ${zabbix_agent_user}:${zabbix_agent_group} ${zabbix_agent_log_dir}
}

_freebsd_zabbix_agent_enable_service() {
    rc_file="/etc/rc.conf"
    sysrc -c zabbix_agentd 2> ${NULL} && return

    grep -iq digitalocean ${rc_file}
    if [[ $? -eq 0 ]]; then
        sed -r -i.bkp 's,(# DigitalOcean Dynamic Configuration lines and the immediate line below it),zabbix_agentd_enable="YES"{{BREAKLINE}}\1,g' ${rc_file} &&
            sed -i.bkp $'s,{{BREAKLINE}},\\\n\\\n,g' ${rc_file}
    fi
}


_freebsd_zabbix_restart_service() {
    service zabbix_agentd restart
}

_freebsd_zabbix_agent_main() {
    _freebsd_zabbix_config_agent
    _freebsd_setup_config
    _freebsd_zabbix_agent_enable_service
    _freebsd_zabbix_restart_service
}
