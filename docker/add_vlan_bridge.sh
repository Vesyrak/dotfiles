sudo ip link set eno1 promisc on
sudo ip link add pivlan link eno1 type macvlan mode bridge
sudo ip addr add 172.16.0.221/32 dev pivlan
sudo ip link set pivlan up
sudo ip route add 172.16.0.220/30 dev pivlan
