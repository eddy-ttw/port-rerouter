#!/bin/bash

# (C) 2026 Andre Grindstaff (eddy-ttw)


# get the raw IP:
ip=$(dig AAAA +short source.domain.com)
	# ipv6 because we aren't boomers


# set up pre-routing

ip6tables -t nat -C PREROUTING -p tcp --dport 25565 -j DNAT --to-destination [${ip}]:25565
ip6tables -t nat -A PREROUTING -p tcp --dport 25565 -j DNAT --to-destination [${ip}]:25565


# set up post-routing

ip6tables -t nat -C POSTROUTING -p tcp -d ${ip} --dport 25565 -j MASQUERADE
ip6tables -t nat -A POSTROUTING -p tcp -d ${ip} --dport 25565 -j MASQUERADE


# fin for 0.1.0
