#!/bin/bash

timedatectl set-timezone Asia/Shanghai

curl -s https://install.zerotier.com | sudo bash

sudo zerotier-cli info

IP_ASSIGNMENT=${secrets.IP_ASSIGNMENT}

memberId=$(sudo zerotier-cli info | awk -F" " '{print $3}')
echo "Member Id is ${memberId}"
curl -X POST
  -H "Content-Type: application/json"
  -H "Authorization: token ${secrets.ZEROTIER_TOKEN}"
  -d "{\"config\": { \"ipAssignments\": [ \"$IP_ASSIGNMENT\" ] }}"
  https://api.zerotier.com/api/v1/network/${secrets.ZEROTIER_NETWORK_ID}/member/${memberId}

sudo zerotier-cli join ${secrets.ZEROTIER_NETWORK_ID}

sleep 10

sudo apt-get update
apt-get install tinyproxy

sudo rm /etc/tinyproxy/tinyproxy.conf
sudo cp tinyproxy.conf /etc/tinyproxy/
sudo service tinyproxy restart

sleep 9999d
