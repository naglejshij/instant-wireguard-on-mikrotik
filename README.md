# Instant Wireguard on Mikrotik
A handy script to quickly set up a wireguard VPN on Mikrotik RouterOS (v7 and above)
## Usage
Clone this repository and run `instant_wireguard_setup.sh`. The script will create a directory with semi-randomized interface name and populate it with an `.rsc` script which would add everything necessary to the router and ready-made config files for all clients.
As of now the implementation of IP address generation is a bit janky, so do not use for networks bigger than /24.
