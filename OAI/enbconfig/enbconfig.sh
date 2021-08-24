#!/bin/bash
sudo -E ~/openairinterface5g/cmake_targets/lte_build_oai/build/lte-softmodem -O ~/openairinterface5g/targets/PROJECTS/GENERIC-LTE-EPC/CONF/enb.band7.tm1.50PRB.usrpb210.conf --rf-config-file ~/openairinterface5g/targets/ARCH/LMSSDR/LimeSDR_below_1p8GHz_1v4.ini --T_stdout 0
#~/openairinterface5g/common/utils/T/tracer/enb -d ../T_messages.txt
