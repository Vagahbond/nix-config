#!/bin/sh

wired_interface=$(ip addr | grep -oP -m1 "(enp0s[0-9]{2}[^: ]+)")

if ip addr show dev $wired_interface | grep -Pq "inet ([[0-9]{1,3}\.){3}[[0-9]{1,3}/[0-9]{1,2}"; then
    icon="󰈀"
    ssid="Wired"
    status="Connected via ethernet"
elif ip addr show dev wlp166s0 | grep -Pq "inet ([[0-9]{1,3}\.){3}[[0-9]{1,3}/[0-9]{1,2}"; then
    icon=""
    ssid=$(wpa_cli status verbose | grep -P "^ssid=(.*)" | grep -o "[^(ssid=)].*$")
    status="Connected to ${ssid}"
else
    icon="󰖪"
    status="No network available"
fi

echo "{\"icon\": \"${icon}\", \"status\": \"${status}\"}" 


# response when wifi 
#Selected interface 'wlp166s0'
#bssid=60:35:c0:59:2e:8e
#freq=2412
#ssid=SFR_2E88
#id=4
#mode=station
#wifi_generation=4
#pairwise_cipher=CCMP
#group_cipher=TKIP
#key_mgmt=WPA2-PSK
#wpa_state=COMPLETED
#ip_address=192.168.1.76
#p2p_device_address=bc:09:1b:f5:21:08
#address=bc:09:1b:f5:21:07
#uuid=29b697b7-845e-5575-810d-86fcad1f9b89
#
#
#wpa_cli response when no wifi 
#Selected interface 'wlp166s0'
#wpa_state=SCANNING
#p2p_device_address=bc:09:1b:f5:21:08
#address=bc:09:1b:f5:21:07
#uuid=29b697b7-845e-5575-810d-86fcad1f9b89
#
#
