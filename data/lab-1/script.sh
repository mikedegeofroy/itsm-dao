#!/bin/bash

show_network_card_info() {
    printf "\n"
    echo "Network Card Information"
    echo "------------------------"
    
    iface=$(ifconfig | grep -o '^[^ ]*' | head -n 1 | cut -d: -f1)

    if [ -z "$iface" ]; then
        echo "No active network interface found!"
        return
    fi
    
    echo "Interface: $iface"
    ifconfig $iface | grep -E "inet |ether"
}


show_ipv4_config() {
    printf "\n"
    echo "IPv4 Configuration"
    echo "------------------"

    iface=$(ifconfig | grep -o '^[^ ]*' | head -n 1)

    if [ -z "$iface" ]; then
        echo "No active network interface found!"
        return
    fi

    ifconfig $iface | grep 'inet ' | awk '{print "IP Address: " $2 "\nNetmask: " $4}'

    route -n | grep 'UG[ \t]' | awk '{print "Gateway: " $2}'

    grep "nameserver" /etc/resolv.conf | awk '{print "DNS: " $2}'
}

configure_scenario_1() {
    printf "\n"
    echo "Configuring network for static IP (Scenario #1)"
    
    iface=$(ifconfig | grep -o '^[^ ]*' | head -n 1)

    if [ -z "$iface" ]; then
        echo "No active network interface found!"
        return
    fi

    ifconfig $iface 10.100.0.2 netmask 255.255.255.0 up

    route add default gw 10.100.0.1

    echo "nameserver 8.8.8.8" | tee /etc/resolv.conf > /dev/null

    echo "Static network configuration applied for Scenario #1"
}

configure_scenario_2() {
    printf "\n"
    echo "Configuring network for dynamic IP (Scenario #2)"
    
    iface=$(ifconfig | grep -o '^[^ ]*' | head -n 1)

    if [ -z "$iface" ]; then
        echo "No active network interface found!"
        return
    fi

    ifconfig $iface down
    ifconfig $iface up
    dhclient $iface

    echo "Dynamic network configuration (DHCP) applied for Scenario #2"
}

# Menu template
while true; do
    echo ""
    echo "Select an option:"
    echo "1. Show network card details"
    echo "2. Show current IPv4 configuration"
    echo "3. Configure network (Scenario #1)"
    echo "4. Configure network (Scenario #2)"
    echo "5. Exit"
    echo ""
    
    read -p "Enter your choice: " choice
    
    case $choice in
        1)
            show_network_card_info
            ;;
        2)
            show_ipv4_config
            ;;
        3)
            configure_scenario_1
            ;;
        4)
            configure_scenario_2
            ;;
        5)
            echo "Exiting..."
            exit 0
            ;;
        *)
            echo "Invalid choice. Please try again."
            ;;
    esac
done
