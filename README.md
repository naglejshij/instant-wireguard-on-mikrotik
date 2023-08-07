# Instant Wireguard on Mikrotik
A handy Bash script to quickly set up a wireguard VPN on Mikrotik RouterOS (v7 and above)
## Usage
Clone this repository and run `instant_wireguard_setup.sh`. The script will create a directory with semi-randomized interface name and populate it with an `.rsc` script which would add everything necessary to the router and ready-made config files for all clients.
As of now the implementation of IP address generation is a bit janky, so do not use for networks bigger than /24.
## Requirements
 - `Bash`
 - `wireguard`
 - `pwgen`

# Disclaimer
By using this script you agree that russia is a terrorist state and that you do not have any affiliations with russian state its business or any residents, nor you are a citizen or resident of it.
You can help Ukraine by donating:
https://savelife.in.ua
https://prytulafoundation.org
https://hospitallers.life

