# TP: Réseaux LTE
## 0. Introduction
Ce TP a pour objectif de vous présenter les différents éléments d’un réseau 4G. Le réseau sera simulé à l’aide du logiciel OpenAirInterface, logiciel en open-source développé par l’école Eurecom. Ce TP se déroule par groupe de 2 ou 3. Vous êtes en la possession de smartphones équipés de carte SIM à programmer, d’une USRP B2xx ainsi que de 2 antennes.

Le réseau mobile LTE est découpé en 2 partie : le réseau d’accès (Radio Access Network ou RAN) et le réseau de coeur (Core Network ou CN). Ce TP utilise deux machines avec l'organisation suivante
- Une machine pour le reseau d’accès. Utiliser L’image oaiENB, le mot de passe est 1234.
- Une machine pour le réseau de coeur. Utiliser l’image oaiEPC, le mot de passe est 1234.

                              +---------------+                             
                              |     Sujet     |                             
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

### Sur l'EPC
Copier coller le dossier oai/ (trouvable dans l’archive du TP) dans /usr/local/etc/
```bash
sudo cp oai/ /usr/local/etc/
```
### Sur l'eNB
Copier coller le fichier enb.band7.tm1.50PRB.usrpb210.conf (trouvable dans l’archive du TP) dans le dossier `~/openairinterface5g/ci-scripts/conf_files/`
```bash
cp enb.band7.tm1.50PRB.usrpb210.conf ~/openairinterface5g/ci-scripts/conf_files/
```
### Description du réseau à mettre en place
Le réseau à mettre en place est le suivant :

                                                                               |enp5s0f1:m10                             
                                                                               |192.1168.10.110/24                       
                                                                               |                                         
                                                                               |                                         
                                                         +---------------------|--------------------------------------+
                                 enp5s0f3                |          enp5s0f3   |                                      |        
                                 192.168.247.103/24      |192.168.247.102/24   |                                      |
                                +---------------+        |     +---------------|  127.0.0.1  +---------------+        |
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

Avant-tout, il est impératif de vérifier si les deux ordinateurs peuvent se connecter. Physiquement, les deux ordinateurs seront connectés par leurs interfaces `enp5s0f2` et `enp5s0f3`. Nous pourrons faire cette vérification par la suite à travers d'un ping.
```
À faire :
* Configurer les interfaces des deux ordinateurs de façon à que les deux machines soient configurés comme dans la figure.
* Vérifier que les deux machines arrivent à se ping.
```
____
**Aide**: utilisez `ifconfig` pour donner des noms particuliers aux différentes addresses : `sudo ifconfig <interface>:<identifiant> <addresse_ip>/<masque> up` -> exemple : `sudo ifconfig enp5s0f1:sxu 172.55.55.102/24 up`.
____
## Configurations nécessaires
Pour que les configurations ci-dessous marchent, il est nécessaire de recompiler le projet pour qu'il soit compatible avec les USRP. Cette configuration est faite sur l'ENB.
```bash
cd ~/openairinterface5g
source oaienv
cd cmake_targets
./build_oai -I --eNB -x --install-system-files -w USRP
```
En deuxième lieu, les certificats que gère l'EPC doivent être mis à jour.
```bash
cd ~/openair-cn/scripts
./check_hss_s6a_certificate /usr/local/etc/oai/freeDiameter/ hss.openair4G.eur
./check_mme_s6a_certificate /usr/local/etc/oai/freeDiameter/ mme.openair4G.eur
```


## 1. Le réseau de cœur
Le réseau de cœur est émulé dans la machine du EPC.
### La HSS
La HSS est une base de données qui contient les informations des abonnés. Dans ce cas, la base de données noSQL Cassandra est utilisée. Pour tester son fonctionnement, les commandes suivantes sont d'utilité.

```bash
service cassandra status ## Affiche le statut de l’application
nodetool status ### Affiche les informations des bases de données de cassandra.
cqlsh ### Permet de rentrer dans l’invite de commande de cassandra et d’effectuer des requêtes vers la base de donnée (par exemple : SELECT * FROM vhss.users_imsi; permet d’obtenir la liste des utilisateurs présents dans la base de donnée).
```

#### Rajout d'un utilisateur
Trois scripts sont fournis dans le repertoire pour permettre le rajout d'un utilisateur. L'information remplie dans cette sections devra être la même lors de la programmation de la carte SIM.
```bash
cd ~/openair-cn/scripts
./data_provisioning_users --apn <APN> --apn2 internet --key <Clé d authentification > --imsi-first <IMSI> --msisdn-first <ISDN> --mme-identity mme.openair4G.eur --no-of-users 1 --realm openair4G.eur --truncate True --verbose True --cassandra-cluster 127.0.0.1
```
____
- **APN** : nom de l’APN auquel l’abonné appartient, c’est le nom de l’APN qu’il faudra rentrer dans le téléphone et dans la configuration de la MME. Il depend de la MCC et de la MNC choisie.
- **KEY** :  Clé de chiffrement qui permet de vérifier que l’abonné est bien celui qu’il prétend être. Cette information se retrouve sur la carte SIM de l’abonné sous le forme du « KI ».
- **IMSI-FIRST** :  L’IMSI permet d’identifier l’abonné dans la base de données.
- **MSISDN-FIRST** : Numéro de téléphone de l’abonné.
- **MME-IDENTITY** : Nom de domaine de la MME. Cette information est interne au core network et peut être configuré /etc/hosts.
- **NO-OF-USERS** : Nombre d’utilisateurs que l’on souhaite ajouter à la base de donnée, si ce nombre est supérieur à 1 l’IMSI et le MSISDN doit être incrémenté de 1 pour chaque nouvel utilisateur.
- **REALM** : nom de domaine de la machine. C’est la partie commune à la fin de tous les domaines de la machine.
- **CASSANDRA-CLUSTER** : IP du serveur cassandra où se trouve la HSS. Pour trouver cette IP il suffit de lancer la commmande « nodetool status ».
____
```bash
cd ~/openair-cn/scripts
./data_provisioning_mme --id 3 --mme-identity mme.openair4G.eur --realm openair4G.eur --ue-reachability 1 --truncate True --verbose True -C 127.0.0.1
```
____
- C : IP du serveur cassandra où se trouve la HSS. Pour trouver cette IP il suffit de lancer la commmande « nodetool status ».
____
Finalement, il est nécessaire de calculer la clé d'authentification correspondante à l'abonné qui vient d'être créé.
```bash
oai_hss -j $PREFIX/hss_rel14.json --onlyloadkey
```
### MME
Le Mobility Management Entity (MME) est l'équipement qui gère la signalisation entre les terminaux (UE). Il est chargé de faire le lien entre UE et HSS pour vérifier les différents droit qu'a l'utilisateur dans le réseau.

____
_À faire_

Modifier le fichier `$PREFIX/mme.conf`. L'utilisation d'éditeurs graphiques comme gedit est fortement recomendé.
_Consignes :_
- **MNC** : Code opérateur, ce sont les 4e et 5e chiffres de l’IMSI.
- **MCC** : Code pays, ce sont les 3 premiers chiffres de l’IMSI.
- **WRR_LIST** : Permet de commuter les paquets en fonction de l’APN de l’abonné. Chaque ligne contient un ID (qui dépend de la mnc et de la mcc, par exemple pour mcc=208 et mnc=93 : tac-lb01.tac-hb00.tac.epc.mnc093.mcc208.3gppnetwork.org) et une adresse IP (l’adresse IP de la PGW-C vers laquelle on doit commmuter les paquets.
- **IP** : Pour la configuration des adresses IP dans le fichier de configuration, ne pas oublier d’ajouter le masque !

**Les paramètres doivent être cohérents avec ceux qui ont été utilisés auparavant.**
____
## Les gateways
### La SPGW-C
Achemine et transmet les paquets de données de l'utilisateur. Pour les UE aux repos, le SGW déclenche le paging lorsque des données de liaison descendante arrivent pour l'UE.
____
_À faire_

Modifier le fichier `PREFIX/spgw_c.conf`. L'utilisation d'éditeurs graphiques comme gedit est fortement recomendé.
_Consignes :_
- **IP** : Pour la configuration des adresses IP dans le fichier de configuration, ne pas oublier d’ajouter le masque !
- **IP_ADDRESS_POOL** : Intervale d’adresses que les UEs pourront utiliser. Attention, l’adresse X.Y.Z.1 est réservée pour la gateway, il ne faut pas la rendre disponible aux UEs. Pas de masque ici.
- **APN_NI** : nom de l’APN auquel l’abonné appartient, c’est le nom de l’APN qui a été rentré dans la HSS. Par exemple pour un MNC de 93 et un MCC de 208 il faut mettre default.mnc093.mcc208.gprs


**Les paramètres doivent être cohérents avec ceux qui ont été utilisés auparavant.**
____
### La SPGW-U
Achemine les données entre l'internet et terminal. Il assure également quelques fonctions de sécurité.
____
_À faire_

Modifier le fichier `$PREFIX/spgw_u.conf `. L'utilisation d'éditeurs graphiques comme gedit est fortement recomendé.
_Consignes :_
**PDN_NETWORK_LIST** : Réseau auquel les UEs appartiennent, ce réseau dépend bien sûr de IP_ADDRESS_POOL de la SPGW-C.
**SPGW-C_LIST** : Adresse de la PGW-C sur l’interface Sxab. Ne pas mettre de masque.

**Les paramètres doivent être cohérents avec ceux qui ont été utilisés auparavant.**
____

### Execution des différents blocs
Lancez quatre terminaux et utilisez un pour l'execution d'un bloc individuel.

_SPGW-C :_
```bash
sudo spgwc -c /usr/local/etc/oai/spgw_c.conf
```
_SPGW-U :_
```bash
echo '200 lte' | sudo tee --append /etc/iproute2/rt_tables
sudo ip r add default via <Addresse IP vers internet> dev enp5s0f0 table lte
# you will have to repeat the following line for each PDN network set in your SPGW-U config file
sudo ip rule add from <IP_ADDRESS_POOL>/<Masque> table lte
# Launch block
sudo spgwu -c /usr/local/etc/oai/spgw_u.conf
```
_HSS_
```bash
sudo oai_hss -j /usr/local/etc/oai/hss_rel14.json
```
_MME_
```bash
/home/tpsn/openair-cn/scripts/run_mme --config-file /usr/local/etc/oai/mme.conf --set-virt-if
```
## 2. Le réseau d'accès
### 2.1. La carte SIM
Connectez l'adaptateur à une machine Windows et retrouvez lancez le logiciel qui permet de programmer la carte SIM (`SIM\GRSIMWrite 3.10\GRSIMWrite.exe`). Rentrez les paramètres choisis.
____
_Aide :_
Une photo qui explique quels paramètres sont à changer peut se retrouver sur le repertoire. 
____
### 2.2. L'Evolved NodeB
La partie d’accès de LTE est seulement formée par l’eNB qui recherche les téléphones présents dans sa cellule. Dans notre cas, l’eNodeB sera émulé par l'USRP B2xx.
____
_À faire_
Modifier le fichier `~/openairinterface5g/ci-scripts/conf_files/enb.band7.tm1.50PRB.usrpb210.conf`. L'utilisation d'éditeurs graphiques comme gedit est fortement recomendé.
_Consignes :_
Rajoutez les addresses IP qui correspondent à votre réseau.

**Les paramètres doivent être cohérents avec ceux qui ont été utilisés auparavant.**
____
#### Execution du eNodeB
Brancher les antennes aux ports RX1_L et TX1_1 de l'USRP et celle-ci à un port USB v3 de l'ENB. 
```bash
cd ~/openairinterface5g/cmake_targets/lte_build_oai/build/
# (le Nice n'est pas obligatoire)
nice -20 sudo -E ./lte-softmodem -O ../../../ci-scripts/conf_files/enb.band7.tm1.50PRB.usrpb210.conf
```
### 2.3. Le téléphone
Après avoir insérer votre carte sim, ajoutez l’APN adéquat dans les paramètres du téléphone.
Faites une recherche de réseaux mobiles et découvrez votre eNB.
Vous pouvez vérifier la connexion de l'UE au eNodeB en regardant les trames s1ap sur wireshark du côté du EPC.
