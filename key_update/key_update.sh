#!/bin/bash
########################################################################
## AUTHOR : Santiago Torres Borda
## CREATION DATE : 12/07/2021
## PURPOSE : Compute a new SQN_MS key to recover from
## synch failure error on OAI EPC
## SPECIAL NOTES: $1: path to hss.log
## 		  $2: Result of SQN_MS xor AK (see wireshark's) FIRST
##		      synch failure
##		  $3: Phone's IMSI
########################################################################
## Version: 1.0
########################################################################
#-------------Compilation of important files-------------#
gcc milenage.c -o milenage > /dev/null
gcc xor.c -o xor >/dev/null
#---------------------Data Retreival---------------------#
# 1. Retreive sensitive info to recal new key
# -> Options::optkey
# -> RIJNDAELKEY: K
# -> rand
OPTKEY=`cat $1|grep Options::optkey|cut -c 34-`
echo '[INFO] OPTKEY = '$OPTKEY

RIJNDAELKEY=`cat $1|grep RijndaelKeySchedule`
RIJNDAELKEY=${RIJNDAELKEY:23:32}
echo '[INFO] RIJNDAELKEY = '$RIJNDAELKEY

RAND=`cat $1|grep rand=`
RAND=${RAND:73:32}
echo '[INFO] RAND = '$RAND

#-------------------SQN_ms Computation-------------------#
# 2. Compute new SQN_ms with milenage.c and xor.c
# -> AK
# -> SQNMS
MILENAGE=`./milenage -f $OPTKEY $RIJNDAELKEY $RAND`
AK=${MILENAGE:255}
echo '[INFO] AK = '$AK
SQNMS=`./xor $AK $2` # $2 = SQN_ms ^ AK
echo '[INFO] SQN_ms = '$SQNMS
INTSQN=$((16#$SQNMS))
echo '[INFO] (int)SQN_ms = '$INTSQN

echo "[INFO] Updating SQN in the database..."
IMSI=$3
cqlsh -e "UPDATE vhss.users_imsi SET SQN = ${INTSQN} WHERE imsi = '${IMSI}';"
echo "[INFO] Update completed successfully"
#-------------------Delete extra files-------------------#
rm xor
rm milenage
