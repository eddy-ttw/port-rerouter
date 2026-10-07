#!/bin/bash

# (C) 2026 Andre Grindstaff (eddy-ttw)


# added legacy IP support for clients connecting over v4


# get the raw IP:
ip=$(dig AAAA +short source.domain.com)
	# ipv6 because we aren't boomers

# ipv4 for legacy
ipv4=$(dig A +short source.domain.com)


# set up pre-routing

ip6tables -t nat -C PREROUTING -p tcp --dport 25565 -j DNAT --to-destination [${ip}]:25565
ip6tables -t nat -A PREROUTING -p tcp --dport 25565 -j DNAT --to-destination [${ip}]:25565


# set up post-routing

ip6tables -t nat -C POSTROUTING -p tcp -d ${ip} --dport 25565 -j MASQUERADE
ip6tables -t nat -A POSTROUTING -p tcp -d ${ip} --dport 25565 -j MASQUERADE



# pre-routing for legacy IP

iptables -t nat -C PREROUTING -p tcp --dport 25565 -j DNAT --to-destination ${ipv4}
iptables -t nat -A PREROUTING -p tcp --dport 25565 -j DNAT --to-destination ${ipv4}


# post-routing for legacy IP

iptables -t nat -C POSTROUTING -p tcp -d ${ipv4} --dport 25565 -j MASQUERADE
iptables -t nat -A POSTROUTING -p tcp -d ${ipv4} --dport 25565 -j MASQUERADE


# fin for 0.2.0

