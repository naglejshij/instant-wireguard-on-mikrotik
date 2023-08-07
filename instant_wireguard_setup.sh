#!/bin/bash

echo "russia is a terrorist state. Agree to proceed [agree/no]"
read confirmation
if [[ $confirmation != "agree" ]]; then 
	exit 1
fi

echo How many clients?
read number_of_clients

echo What is server\'s IP address?
read server_ip

current_client=1
client_configs=()
wg_interface_name="wireguard_$(pwgen -A 6 1)"
listen_port=$((1500 + $RANDOM % 9999))
network="10.$((1 + $RANDOM % 254)).0"
host=1
server_private_key=$(wg genkey)
server_public_key=$(echo $server_private_key | wg pubkey)
server_ip_address=$network.$host
mt_config="$wg_interface_name/$wg_interface_name.rsc"


echo "Current client value set to: $current_client"
echo "Wireguard interface name: $wg_interface_name"
echo "Listen port: $listen_port"

mkdir "$wg_interface_name"

echo "/interface/wireguard/add name=$wg_interface_name listen-port=$listen_port disabled=no comment=$wg_interface_name private-key=\"$server_private_key\"" >> $mt_config
echo "/ip/address/add address=$network.$host/24 interface=$wg_interface_name disabled=no" >> $mt_config
echo "/ip/firewall/filter/add action=accept dst-port=$listen_port dst-address=$server_ip protocol=udp place-before=2 comment=\"$wg_interface_name inbound\""

host=$((host + 1))


cat > $wg_interface_name/peer.conf << EOF
[Peer]
PublicKey = $server_public_key
AllowedIPs = $network.0/24
Endpoint = $server_ip:$listen_port
PersistentKeepalive = 25
EOF

while [[ $current_client -le $number_of_clients ]] ; do
	echo "Generating client $current_client"
	private_key=$(wg genkey)
	preshared_key=$(wg genpsk)
	public_key=$(echo $private_key | wg pubkey)
	
	echo "======================"
	echo "/interface/wireguard/peers/add interface=$wg_interface_name allowed-address=$network.$host/24 public-key=\"$public_key\" preshared-key=\"$preshared_key\" persistent-keepalive=25 comment=\"client $current_client for $wg_interface_name\"" >> $mt_config
	
	client_file="$wg_interface_name/client_$current_client.conf"
	cat > $client_file << EOF
[Interface]
PrivateKey = $private_key
Address = $network.$host
DNS = 1.1.1.1, 1.0.0.1
	
EOF
cat $wg_interface_name/peer.conf >> $client_file
echo "PresharedKey = $preshared_key" >> $client_file
	
	host=$((host + 1))
	current_client=$((current_client + 1))
done

rm $wg_interface_name/peer.conf
