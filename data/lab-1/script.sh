#!/bin/bash

# Function to show network card details
show_network_card_info() {
    echo "Network Card Information"
    echo "------------------------"
    # Get interface name (assuming eth0, you can modify as needed)
    iface=$(ip -o -4 route show to default | awk '{print $5}')
    
    if [ -z "$iface" ]; then
        echo "No active network interface found!"
        return
    fi
    
    echo "Interface: $iface"
    # Show NIC model, speed, duplex, and link status
    ethtool $iface | grep "Speed\|Duplex\|Link detected"
    
    # Show MAC address
    echo "MAC Address: $(cat /sys/class/net/$iface/address)"
}

# Function to show current IPv4 configuration
show_ipv4_config() {
    echo "IPv4 Configuration"
    echo "------------------"
    
    iface=$(ip -o -4 route show to default | awk '{print $5}')
    
    if [ -z "$iface" ]; then
        echo "No active network interface found!"
        return
    fi
    
    ip addr show $iface | grep "inet " | awk '{print "IP Address: " $2}'
    ip route | grep default | awk '{print "Gateway: " $3}'
    grep "nameserver" /etc/resolv.conf | awk '{print "DNS: " $2}'
}

# Function to configure network according to scenario #1
configure_scenario_1() {
    echo "Configuring network for scenario #1"
    iface=$(ip -o -4 route show to default | awk '{print $5}')
    
    if [ -z "$iface" ]; then
        echo "No active network interface found!"
        return
    fi
    
    # Set temporary IP (modify this according to your needs)
    sudo ip addr flush dev $iface
    sudo ip addr add 192.168.1.100/24 dev $iface
    sudo ip route add default via 192.168.1.1
    
    echo "Temporary network configuration applied for Scenario #1"
}

# Function to configure network according to scenario #2
configure_scenario_2() {
    echo "Configuring network for scenario #2"
    iface=$(ip -o -4 route show to default | awk '{print $5}')
    
    if [ -z "$iface" ]; then
        echo "No active network interface found!"
        return
    fi
    
    # Set temporary IP (modify this according to your needs)
    sudo ip addr flush dev $iface
    sudo ip addr add 192.168.0.200/24 dev $iface
    sudo ip route add default via 192.168.0.1
    
    echo "Temporary network configuration applied for Scenario #2"
}

# Main menu
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
