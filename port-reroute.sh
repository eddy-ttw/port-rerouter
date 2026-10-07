#!/bin/bash

# (C) 2026 Andre Grindstaff (eddy-ttw)

# Port rerouter v0.3.0

# added legacy IP support for clients connecting over v4


# variables
# -----------

# port #:
port=25565


# get the raw IP:
ip=$(dig AAAA +short source.domain.com)
	# ipv6 because we aren't boomers

# ipv4 for legacy
ipv4=$(dig A +short source.domain.com)


# set up pre-routing

ip6tables -t nat -C PREROUTING -p tcp --dport 25565 -j DNAT --to-destination [${ip}]:${port}
ip6tables -t nat -A PREROUTING -p tcp --dport 25565 -j DNAT --to-destination [${ip}]:${port}


# set up post-routing

ip6tables -t nat -C POSTROUTING -p tcp -d ${ip} --dport ${port} -j MASQUERADE
ip6tables -t nat -A POSTROUTING -p tcp -d ${ip} --dport ${port} -j MASQUERADE



# pre-routing for legacy IP

iptables -t nat -C PREROUTING -p tcp --dport ${port} -j DNAT --to-destination ${ipv4}
iptables -t nat -A PREROUTING -p tcp --dport ${port} -j DNAT --to-destination ${ipv4}


# post-routing for legacy IP

iptables -t nat -C POSTROUTING -p tcp -d ${ipv4} --dport ${port} -j MASQUERADE
iptables -t nat -A POSTROUTING -p tcp -d ${ipv4} --dport ${port} -j MASQUERADE


# fin

