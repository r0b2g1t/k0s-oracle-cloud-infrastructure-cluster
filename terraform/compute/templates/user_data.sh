#!/bin/bash
sudo iptables -I INPUT -p tcp -m tcp --dport 2380 -j ACCEPT
sudo iptables -I INPUT -p tcp -m tcp --dport 4789 -j ACCEPT
sudo iptables -I INPUT -p tcp -m tcp --dport 6443 -j ACCEPT
sudo iptables -I INPUT -p tcp -m tcp --dport 8132 -j ACCEPT
sudo iptables -I INPUT -p tcp -m tcp --dport 8133 -j ACCEPT
sudo iptables -I INPUT -p tcp -m tcp --dport 9443 -j ACCEPT
sudo iptables -I INPUT -p tcp -m tcp --dport 10250 -j ACCEPT
sudo iptables -I INPUT -p tcp -m tcp --dport 30080 -j ACCEPT
sudo iptables -I INPUT -p tcp -m tcp --dport 30443 -j ACCEPT
sudo /sbin/iptables-save > /etc/iptables/rules.v4
sudo chmod 666 /etc/environment
sudo crontab -l | { cat; echo '* * * * *   sync; echo 3 >'/proc/sys/vm/drop_caches' && swapoff -a && swapon -a'; } | sudo crontab -