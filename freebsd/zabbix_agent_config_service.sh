#!/usr/bin/env bash

NAMESPACE="freebsd"

zabbix_agent_user='zabbix'
zabbix_agent_group='zabbix'

zabbix_agent_conf_file='/usr/local/etc/zabbix4/zabbix_agentd.conf'

zabbix_agent_log_dir='/var/log/zabbix'
zabbix_agent_log_file='zabbix_agentd.log'

zabbix_agent_basic_conf="
LogFile=${zabbix_agent_log_dir}/${zabbix_agent_log_file}
Hostname={{HOSTNAME}}
Server={{SERVER}}
ServerActive={{SERVER}}
"

_freebsd_zabbix_config_file(){
    if [ -f ${zabbix_agent_conf_file} ]; then
        cp -v ${zabbix_agent_conf_file} ${zabbix_agent_conf_file}.samples
    fi
    echo "${zabbix_agent_conf_file}"
}

_freebsd_zabbix_config_agent() {
    file="$(_freebsd_zabbix_config_file())"
    servers="$(echo ${ZABBIX_SERVERS} | tr ' ' ',')"
    hostname="${HOSTNAME}"

    echo ${zabbix_agent_basic_conf} |
        sed "s,{{HOSTNAME}},${hostname},g" |
        sed "s,{{SERVER}},${servers},g" > ${file}
}

_freebsd_setup_config() {
    mkdir -p ${zabbix_agent_log_dir}
    touch ${zabbix_agent_log_dir}/${zabbix_agent_log_file}
    chown -R ${zabbix_agent_user}:${zabbix_agent_group} ${zabbix_agent_log_dir}
}


_freebsd_zabbix_restart_service() {
    service zabbix_agentd restart
}

_freebsd_zabbix_agent_main() {
    _freebsd_zabbix_config_agent
    _freebsd_setup_config
    _freebsd_zabbix_restart_service
}
