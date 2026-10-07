#!/bin/bash

# (C) 2026 Andre Grindstaff (eddy-ttw)

# Port rerouter v0.4.0.2

# TODO: add config file support!

# Variables
# -----------

# NOTICE:
# You now can use the config.cfg file to set these variables, instead of
# modifying them here!


# domain (source) to get its IP from
domain='source.domain.com'

# port #:
port=80


# do not modify the lines below!
# ===========================================

# defaults
no_ipv4=0
no_ipv6=0

# internal
ver=0.4.0.2


# Get config
get_config () {
	if [ -f "$PWD/portreroute.cfg" ]; then
        config_path="$PWD/portreroute.cfg"
    elif [ -f "$PWD/config.cfg" ]; then
        config_path="$PWD/config.cfg"    
    elif [ -f "/opt/eddyttw0/port-rerouter/config.cfg" ]; then
        config_path="/opt/eddyttw0/port-rerouter/config.cfg"
	elif [ -f "/opt/eddyttw0/port-reroute/config.cfg" ]; then
        config_path="/opt/eddyttw0/port-reroute/config.cfg"

    elif [ -f "/opt/eddyttw0/port-rerouter/portreroute.cfg" ]; then
        config_path="/opt/eddyttw0/port-rerouter/portreroute.cfg"
	elif [ -f "/opt/eddyttw0/port-reroute/config.cfg" ]; then
        config_path="/opt/eddyttw0/port-reroute/portreroute.cfg"
	fi

    if [ -v config_path ]; then
        # import values
        echo "Found config at: ${config_path}"
        source "$config_path"
    fi
}



# Processing
# -----------

get_ip () {
	# get the raw IP:
	
	ip=$(dig AAAA +short ${domain})
	# ipv6 because we aren't boomers

	# ipv4 for legacy
	ipv4=$(dig A +short ${domain})
}

chk_ip () {
	echo [TODO] Will check IPs in next update...
}


do_routing () {
	# set up pre-routing

	ip6tables -t nat -C PREROUTING -p tcp --dport $port -j DNAT \
		--to-destination [${ip}]:${port}
	ip6tables -t nat -A PREROUTING -p tcp --dport $port -j DNAT \
		--to-destination [${ip}]:${port}


	# set up post-routing
	
	ip6tables -t nat -C POSTROUTING -p tcp -d ${ip} --dport $port -j MASQUERADE
	ip6tables -t nat -A POSTROUTING -p tcp -d ${ip} --dport $port -j MASQUERADE
}


do_routing_v4 () {
	# pre-routing for legacy IP

	iptables -t nat -C PREROUTING -p tcp --dport $port -j DNAT \
		--to-destination ${ipv4}
	iptables -t nat -A PREROUTING -p tcp --dport $port -j DNAT \
		--to-destination ${ipv4}


	# post-routing for legacy IP

	iptables -t nat -C POSTROUTING -p tcp -d ${ipv4} --dport $port -j MASQUERADE
	iptables -t nat -A POSTROUTING -p tcp -d ${ipv4} --dport $port -j MASQUERADE

}

init () {
	echo [TODO] Will be implemented...
}

main () {
	echo "Port Rerouter v${ver}"
	
	get_config
	get_ip
	
	# future release will have switching
	do_routing
	
	do_routing_v4
}

main
# fin
