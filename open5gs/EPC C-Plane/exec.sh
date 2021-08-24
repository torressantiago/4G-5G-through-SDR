#!/bin/bash
/home/open5g/open5gs/install/bin/open5gs-nrfd&
sleep 5
/home/open5g/open5gs/install/bin/open5gs-smfd&
/home/open5g/open5gs/install/bin/open5gs-amfd&
/home/open5g/open5gs/install/bin/open5gs-ausfd&
/home/open5g/open5gs/install/bin/open5gs-udmd&
/home/open5g/open5gs/install/bin/open5gs-udrd&
/home/open5g/open5gs/install/bin/open5gs-pcfd&
/home/open5g/open5gs/install/bin/open5gs-nssfd&
