#!/bin/bash

# Variables
SSID="test_ssid"
PSK="asleiv)43hwa4"
INTERFACE="wlp0s20f3" # Replace with your actual Wi-Fi interface name

echo "using $INTERFACE"

# Disable current interface
nmcli device disconnect $INTERFACE

# Create the connection
nmcli con add type wifi ifname "$INTERFACE" con-name "$SSID" autoconnect yes ssid "$SSID"

# Configure the hotspot settings
nmcli con modify "$SSID" 802-11-wireless.mode ap
nmcli con modify "$SSID" ipv4.method shared

# Configure Wi-Fi security
nmcli con modify "$SSID" wifi-sec.key-mgmt wpa-psk
nmcli con modify "$SSID" 802-11-wireless-security.pairwise ccmp
nmcli con modify "$SSID" 802-11-wireless-security.group ccmp
nmcli con modify "$SSID" 802-11-wireless-security.proto rsn
nmcli con modify "$SSID" wifi-sec.psk "$PSK"

# Disable PMF (Protected Management Frames)
nmcli con modify "$SSID" wifi-sec.pmf disable

# Bring up the connection
nmcli con up "$SSID"

# Check the status
if [ $? -eq 0 ]; then
    echo "Hotspot setup successfully!"
else
    echo "Failed to set up the hotspot."
    nmcli con delete "$SSID"
fi

