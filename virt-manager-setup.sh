#!/usr/bin/env bash

network_config_file=/etc/libvirt/qemu/networks/default.xml
user=$USER

# Install required packages
# 
#TODO add a brief explanation regarding each one of these packets
sudo pacman -S virt-manager qemu-full dnsmasq bridge-utils edk2-ovmf swtpm

# add current user to the libvirt and libvirt-qemu groups
# if other users will operate the virt-manager, add those with UIDs above 1000 to these groups
sudo usermod -a -G libvirt $user
sudo usermod -a -G libvirt-qemu $user
# also enable editing the XML config files and the virt-manager tray icon
sudo -u $user XDG_RUNTIME_DIR=/run/user/$(id -u $user) gsettings set org.virt-manager.virt-manager xmleditor-enabled true
sudo -u $user XDG_RUNTIME_DIR=/run/user/$(id -u $user) gsettings set org.virt-manager.virt-manager system-tray true

# Backup the config file if another file already exists and isn't backed up
if [ ! -e "${network_file}.bkp" ] && [ -e "$network_file" ];then
    sudo cp "$network_file" "${network_file}.bkp"
fi

# Check if the IP range used by libvirt is already use by another network and change it
libvirtNetRange=$(sudo grep -oP "(?<=ip address=')[0-9]+\.[0-9]+\.[0-9]+" "$network_config_file")
if [ -n "$(ip -o -4 a | grep $libvirtNetRange)" ]; then
    newLibvirtNetRange=$(awk -F. '{print $1 "." $2 "." $3+1}' <<< $libvirtNetRange)
    sudo sed -i "s/$libvirtNetRange/$newLibvirtNetRange/g" "$network_config_file"
fi

# Allow the bridge on all host networks
if [ -e /etc/qemu/bridge.conf ] && [ -z "$(grep 'allow all' /etc/qemu/bridge.conf)" ]; then
    echo "allow all" | sudo tee -a /etc/qemu/bridge.conf > /dev/null
fi

# Start libvirtd
sudo systemctl start libvirtd.service

# Setup, start and enable on boot the default libvirt network
network=$(LANG=C virsh net-list | grep default)
if [ -z "$network" ];then
    sudo virsh net-define "$network_config_file"
fi
network=$(LANG=C virsh net-list | grep default)
if [ "$(awk '{print $2}' <<< $network)" != "active" ];then
    sudo virsh net-start default
fi
network=$(LANG=C virsh net-list | grep default)
if [ "$(awk '{print $3}' <<< $network)" != "yes" ];then
    sudo virsh net-autostart default
fi

# Enable loading libvirtd on system boot
sudo systemctl enable libvirtd.service

# Enable IPv4 packet forwarding on kernel (required for port forwarding, etc)
sudo sysctl -w net.ipv4.ip_forward=1 >/dev/null
