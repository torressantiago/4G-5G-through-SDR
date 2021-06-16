# LTE through SDR
This project aims to emulate LTE (and 5G eventually) by using linux machines and some SDR devices. In this particular case, two computers are used, one for the Evolved Packet Core (EPC) and the other for the Evolved NodeB (ENB). The first one is using Ubuntu 18.04 LTS and the other Ubuntu 16.04 LTS. These are the tested distributions, but other versions of Ubuntu, notably 14.04 LTS, should work well with the presented configuration bellow. For the SDR side of things, three devices were tested: USRP B200, URSP B210 and USRP X310. 

For the emulation the [openairinterface project](https://gitlab.eurecom.fr/oai) will be used. Developed at eurecom, it checks every box for a good, flexible, portable and evolving testbed.

# The network

# Configuration
This configuration uses the configuration files found in this repository. Although it should work with more recent iterations of [openairinterface](https://gitlab.eurecom.fr/oai), compatibility is not guaranteed. 

The application presented in this section uses preconfigurated files, as well as scripts, that reconstruct the network shown in the *network* section. For more detail on what to change openairinterface's documentation will be handy. 

## Some useful documentation
* https://gitlab.eurecom.fr/oai/openairinterface5g/-/wikis/home
* https://gitlab.eurecom.fr/oai/openairinterface5g/-/wikis/HowToConnectCOTSUEwithOAIeNBNew
* https://www.openairinterface.org/docs/workshop/8_Fall2019Workshop-Beijing/Training/2019-12-03-KALTENBERGER-1.pdf

## Evolved NodeB
Deploying the eNodeB is relatively easy. Two steps are mandatory. First, the network must be configured.
```bash
sudo ip add add 192.168.247.103/24 dev enp5s0f3
sudo ip add add 192.168.14.1/24 dev enp5s0f1
sudo ip add add 192.168.248.160/24 dev enp5s0f2
```
Remember to change the network interfaces to suit your local configuration.

Then the ENB deploy. Under the [openairinterface](https://gitlab.eurecom.fr/oai) repository for the ENB side, is `lte-softmodem` which allows us to emulate the whole block. As an argument it takes the `enb.band7.tm1.50PRB.usrpb210.conf` file. This file contains the different ip addresses the ENB should look at (i.e. the MME and SPGW-U IP address). It is there that the physical layer aspects are defined, the antenna gain, the frequency band, etc. `lte-softmodem` will then interface these parameters with the SDR's FPGA. 

Here's how to deploy the ENB:

```bash
nice -20 sudo -E /home/oaienb/openairinterface5g/cmake_targets/lte_build_oai/build/lte-softmodem -O ../../../ci-scripts/conf_files/enb.band7.tm1.50PRB.usrpb210.conf
```
## Evolved Packet Core

## Some (hopefully) useful notes
### Scripts to simplify configuration

### The certificate problem
When launching the EPC, there might be an issue because of the repository's certificates while deploying the MME. These certificates are used for authentication by the MME and HSS. All you have to do is update the certificates. These will expire one year after their generation.

```bash
cd EPC_REPO_PATH/openair-cn/SCRIPTS
./check_hss_s6a_certificate /usr/local/etc/oai/freeDiameter/ hss.openair4G.eur
./check_mme_s6a_certificate /usr/local/etc/oai/freeDiameter/ nano.openair4G.eur
```

### Updating SDR device
If you'd like to change the family of the device you're using for SDR, you'll have to recompile `build_oai` and the scripts it uses. Some examples on how to do so are below.
```bash
cd ENB_REPO_PATH/openairinterface
source oaienv
cd cmake_targets
./build_oai -I --eNB -x --install-system-files -w USRP       #for USRP
./build_oai -I  --eNB -x --install-system-files -w EXMIMO    #for EXMIMO
./build_oai -I  --eNB -x --install-system-files -w BLADERF   #for BladeRF

```