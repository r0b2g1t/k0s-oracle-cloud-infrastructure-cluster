#!/bin/bash
sudo iptables -I INPUT -p tcp -m tcp --dport 9443 -j ACCEPT
sudo /sbin/iptables-save > /etc/iptables/rules.v4
sudo chmod 666 /etc/environment