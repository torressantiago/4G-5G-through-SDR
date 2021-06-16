# LTE through SDR
This project aims to emulate LTE (and 5G eventually) by using linux machines and some SDR devices. In this particular case, two computers are used, one for the Evolved Packet Core (EPC) and the other for the Evolved NodeB (ENB). The first one is using Ubuntu 18.04 LTS and the other Ubuntu 16.04 LTS. These are the tested distributions, but other versions of Ubuntu, notably 14.04 LTS, should work well with the presented configuration bellow. For the SDR side of things, three devices were tested: USRP B200, URSP B210 and USRP X310. 

For the emulation the [openairinterface projet](https://gitlab.eurecom.fr/oai) will be used. Developed at eurecom, it checks every box for a good, flexible, portable and evolving testbed.

# The network

# Configuration
This configuration uses the configuration files found in this repository. Although it should work with more recent iterations of [openairinterface](https://gitlab.eurecom.fr/oai), compatibility is not guaranteed. 

The application presented in this section uses preconfigurated files, as well as scripts, that reconstruct the network shown in the *network* section. For more detail on what to change openairinterface's documentation will be handy. 

## Some useful documentation
* https://gitlab.eurecom.fr/oai/openairinterface5g/-/wikis/home
* https://gitlab.eurecom.fr/oai/openairinterface5g/-/wikis/HowToConnectCOTSUEwithOAIeNBNew
* https://www.openairinterface.org/docs/workshop/8_Fall2019Workshop-Beijing/Training/2019-12-03-KALTENBERGER-1.pdf

## Evolved NodeB
## Evolved Packet Core
