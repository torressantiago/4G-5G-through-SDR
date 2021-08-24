echo '200 lte' | sudo tee --append /etc/iproute2/rt_tables
# Here the gateway is not at 192.168.78.245
sudo ip r add default via 147.127.245.84 dev eth0 table lte
# you will have to repeat the following line for each PDN network set in your SPGW-U config file
sudo ip rule add from 12.1.1.0/24 table lte




######################################################################################################################
#    PDN_NETWORK_LIST  = (                                                         				     #
#                      {NETWORK_IPV4 = "12.1.1.0/24"; NETWORK_IPV6 = "2001:1:2::0/64"; SNAT = "yes";}                #
#                    );												     #
#														     #
######################################################################################################################







