# LTE through SDR
This project aims to emulate LTE (and 5G eventually) by using linux machines and some SDR devices. In this case, two computers are used, one for the Evolved Packet Core (EPC) and the other for the Evolved NodeB (ENB). The first one is using Ubuntu 18.04 LTS and the other Ubuntu 16.04 LTS. These are the tested distributions, but other versions of Ubuntu, notably 14.04 LTS, should work well with the configuration below. For the SDR side of things, three devices were tested: USRP B200, URSP B210 and USRP X310. 

For emulation, the [openairinterface project](https://gitlab.eurecom.fr/oai) will be used. Developed at eurecom, it checks every box for a good, flexible, portable and evolving testbed.

# The network
                                                                               |enp5s0f1:m10                             
                                                                               |192.1168.10.110/24                       
                                                                               |                                         
                                                                               |                                         
                                                         +---------------------|--------------------------------------+
                                 enp5s0f3                |          enp5s0f3   |                                      |        
                                 192.168.247.103/24      |192.168.247.102/24   |                                      |
                              +---------------+          |     +---------------|  127.0.0.1  +---------------+        |
      ---------------------------      ENB      ----------------      MME      ---------------      HSS      |        |
      enp5s0f1                  +--------\------+        |     +----------\----+             +---------------+        |
      192.168.14.1/24      enp5s0f2       --\            |     enp5s0f1:m11-------\                                   |
                           192.168.248.160/24---\        |     172.16.1.102/24     ------\   +---------------+        |
                                                --\      |                                ----     SGW-C     |        |
                                                   --\   |                       enp5s0f1:s11+-------|-------+        |
                                                      ---\                       172.16.1.104/24     |enp5s0f1:s5c    |
                                                         --\                                         |172.58.58.102/24|
                                                         |  --\                                      |                |
                                                         |     ---\   enp5s0f2                       |enp5s0f1:p5c    |
                                                         |         --\192.168.248.159/24             |172.58.58.101/24|
                              +---------------+          |     +---------------+             +-------|-------+        |
                              |    Internet   -----------|------    SPGW-U     ---------------     SPGW-C    |        |
                              +---------------+          |     +---------------+             +---------------+        |
                                                         |            enp5s0f1:sxu         enp5s0f1:sxc               |
                                                         |            172.55.55.102/24 172.55.55.101/24               |
                                                         |                                                        EPC |
                                                         +------------------------------------------------------------+
# The configuration
This configuration uses the configuration files found in this repository. Although it should work with more recent iterations of [openairinterface](https://gitlab.eurecom.fr/oai), compatibility is not guaranteed. 

Since this repository aims to be an LTE testbed, the application presented in this section uses preconfigurated files and scripts, that reconstruct the network shown in the *network* section. For more detail on what to change, openairinterface's documentation will be handy. 

## Some useful documentation
* https://gitlab.eurecom.fr/oai/openairinterface5g/-/wikis/home
* https://gitlab.eurecom.fr/oai/openairinterface5g/-/wikis/HowToConnectCOTSUEwithOAIeNBNew
* https://www.openairinterface.org/docs/workshop/8_Fall2019Workshop-Beijing/Training/2019-12-03-KALTENBERGER-1.pdf

## Project structure
                              +---------------+                             
                              |  Github repo  |                             
                              +---------------+                             
                              --/           \--                             
                           ---/                 \--                          
                        --/                        \--                       
               +--------/------+                +------\--------+             
               |      ENB      |                |      EPC      |             
               +-------/-------+                +------/--\-----+             
                     /-                              /-    ---\               
                  /                              /-          ---\           
      +------------------------+          +---------------+  +---------------+
      |   openairinterface5g   |          |   openair-cn  |  |      oai      |
      +------------------------+          +---------------+  +---------------+

Since this project is to be deployed on two different computers, the figure above shows the expected organization.

## Evolved NodeB
Deploying the eNodeB is relatively easy. Two steps are mandatory. First, the network must be configured.
```bash
sudo ip add add 192.168.247.103/24 dev enp5s0f3
sudo ip add add 192.168.14.1/24 dev enp5s0f1
sudo ip add add 192.168.248.160/24 dev enp5s0f2
```
Remember to change the network interfaces to suit your local configuration.

Then the ENB deploy. Under the [openairinterface](https://gitlab.eurecom.fr/oai) repository for the ENB side, is teh executable `lte-softmodem` which allows us to emulate the whole block. As an argument it takes the configuration file `enb.band7.tm1.50PRB.usrpb210.conf`, that contains the different ip addresses the ENB should look at (i.e. the MME and SPGW-U IP address). It is there that the physical layer aspects are defined, the antenna gain, the frequency band, etc. `lte-softmodem` will then interface these parameters with the SDR's FPGA. 

Here is how to deploy the ENB:
```bash
cd PATH_TO_REPO/openairinterface5g/cmake_targets/lte_build_oai/build/
# (Nice is not mandatory)
nice -20 sudo -E ./lte-softmodem -O ../../../ci-scripts/conf_files/enb.band7.tm1.50PRB.usrpb210.conf
```
## Evolved Packet Core
On the other hand, the EPC requires much more configuration. In preamble to the EPC's configuration, the oai folder must be moved to `/usr/local/etc/`. Supposing you are placed where you downloaded the oai folder, the following command can be used. 
```bash
sudo mv oai/ /usr/local/etc/
```

Once the oai repository is correctly placed, the network must be configured correctly.

```bash 
# MME
sudo ifconfig enp5s0f3:m11 172.16.1.102/24 up
sudo ip addr add 192.168.247.102/24 dev enp5s0f3 # M1C

# SPGW C
sudo ifconfig enp5s0f1:sxc 172.55.55.101/24 up # SPGW-C SXab interface
sudo ifconfig enp5s0f1:s5c 172.58.58.102/24 up # SGW-C S5S8 interface
sudo ifconfig enp5s0f1:p5c 172.58.58.101/24 up # PGW-C S5S8 interface
sudo ifconfig enp5s0f1:s11 172.16.1.104/24 up  # SGW-C S11 interface

#SPGW-U
sudo ifconfig enp5s0f1:sxu 172.55.55.102/24 up   # SPGW-U SXab interface
sudo ip addr add 192.168.248.159/24 dev enp5s0f2 # SPGW-U S1U interface
```

Remember that network interfaces can be changed to suit your current configuration.

Now that imperative configurations are in place configurations for the different blocks can begin. First the HSS. This part requires to specify the network's name, the authentification key, its IMSI and MSISDN. The following set of commands allows us to do so.

```bash
PATH_TO_REPO/openair-cn/scripts/data_provisioning_users --apn default.mnc093.mcc208.gprs --apn2 internet --key fec86ba6eb707ed08905757b1bb44b8f --imsi-first 208930000000007 --msisdn-first 1011234561010 --mme-identity mme.openair4G.eur --no-of-users 1 --realm openair4G.eur --truncate True --verbose True --cassandra-cluster 127.0.0.1
```
```bash
PATH_TO_REPO/openair-cn/scripts/data_provisioning_mme --id 3 --mme-identity mme.openair4G.eur --realm openair4G.eur --ue-reachability 1 --truncate True --verbose True -C 127.0.0.1
```
The parameters set will be used to register a user in the HSS database so that connection is accepted for any UE identifying itself with those. Then, a key that summarises the authentication data described is generated.

```bash
oai_hss -j /usr/local/etc/oai/hss_rel14.json --onlyloadkey
```

Once this is done, the MME can be executed.

```bash
sudo oai_hss -j /usr/local/etc/oai/hss_rel14.json
```

The rest of blocks require to edit their respective configuration files which can be found at `/usr/local/etc/oai`. 

MME execution:
```bash
/home/tpsn/openair-cn/scripts/run_mme --config-file /usr/local/etc/oai/mme.conf --set-virt-if
```

SPGW-C execution:
```bash
sudo spgwc -c /usr/local/etc/oai/spgw_c.conf
```

SPGW-U execution:
```bash
echo '200 lte' | sudo tee --append /etc/iproute2/rt_tables
# Here the gateway is not at 192.168.78.245
sudo ip r add default via 147.127.245.56 dev enp5s0f0 table lte
# you will have to repeat the following line for each PDN network set in your SPGW-U config file
sudo ip rule add from 12.1.1.0/24 table lte
# Launch block
sudo spgwu -c /usr/local/etc/oai/spgw_u.conf
```

____
NOTE: The IP addresses shown are meant for the specific network shown in the previous section. Feel free to change them according to your design.
____

## Some (hopefully) useful notes
### Scripts to simplify configuration
A script has been developped to simplify configuration. 

### The certificate problem
When launching the EPC, there might be an issue because of the repository's certificates while deploying the MME. These certificates are used for authentication by the MME and HSS. All you have to do is update the certificates. These will expire one year after their generation.

```bash
cd EPC_REPO_PATH/openair-cn/SCRIPTS
./check_hss_s6a_certificate /usr/local/etc/oai/freeDiameter/ hss.openair4G.eur
./check_mme_s6a_certificate /usr/local/etc/oai/freeDiameter/ mme.openair4G.eur
```

### Updating SDR device
If you'd like to change the family of the device, you're using for SDR, you'll have to recompile `build_oai` and the scripts it uses. Some examples on how to do so are below.
```bash
cd ENB_REPO_PATH/openairinterface
source oaienv
cd cmake_targets
./build_oai -I --eNB -x --install-system-files -w USRP       #for USRP
./build_oai -I  --eNB -x --install-system-files -w EXMIMO    #for EXMIMO
./build_oai -I  --eNB -x --install-system-files -w BLADERF   #for BladeRF

```
### Configuring the SIM card

