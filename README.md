# Introduction
Ce projet a pour but de montrer les différentes façons d'implémenter un réseau 5G à travers _Software-defined Radio_ (SDR) et _Software-defined Network_ (SDN). Pour cela, divers projets _Open Source_ sont utilisés de façon à diversifier les possibles solutions et permettre à l'utilisateur de ce répertoire une ample compréhension de l'état de l'art actuel.

# Implémentations
* 4G LTE : OpenAir Interface LTE ([Installation](https://github.com/torressantiago/4G-5G-through-SDR/wiki/Installation-de-openairinterface5g)/[Implémentation](https://github.com/torressantiago/4G-5G-through-SDR/wiki/Impl%C3%A9mentation-de-OpenAir-Interface-4G)) -> Bare Metal
* 4G LTE : srsRAN ([Installation](https://github.com/torressantiago/4G-5G-through-SDR/wiki/Installation-de-srsRAN)/[Implémentation](https://github.com/torressantiago/4G-5G-through-SDR/wiki/Impl%C3%A9mentation-de-srsRAN)) -> Bare Metal
* 5G NSA : OpenAir Interface LTE/5G ([Installation](https://github.com/torressantiago/4G-5G-through-SDR/wiki/Installation-de-openairinterface5g)/[Implémentation](https://github.com/torressantiago/4G-5G-through-SDR/wiki/Impl%C3%A9mentation-de-OpenAir-Interface-5G-NSA)) -> Bare Metal
* 5G SA (Accès radio émulé): Open5GS + UERANSIM ([Installation](https://github.com/torressantiago/4G-5G-through-SDR/wiki/Installation-Open5GS)/[Implémentation](https://github.com/torressantiago/4G-5G-through-SDR/wiki/Impl%C3%A9mentation-de-5G-SA-avec-Open5GS)) -> VM (possible sur bare metal)
* 5G SA (Accès radio émulé): OpenAir Interface 5G NR ([Installation](https://github.com/torressantiago/4G-5G-through-SDR/wiki/Installation-de-openairinterface-5G-SA)/[Implémentation](https://github.com/torressantiago/4G-5G-through-SDR/wiki/Impl%C3%A9mentation-de-5G-SA-avec-OpenAir-Interface)) -> VM (Possible sur bare metal)

# Aide
- [OpenAir Interface](https://github.com/torressantiago/4G-5G-through-SDR/wiki/Impl%C3%A9mentation-de-OpenAir-Interface-4G#synch-failure-error) -> Synch failure/Expired certificates
- [UHD](https://kb.ettus.com/Building_and_Installing_the_USRP_Open-Source_Toolchain_(UHD_and_GNU_Radio)_on_Linux) -> Réinstallation en cas de mauvaise configuration.

# Tutoriels
* [Configuration](https://github.com/torressantiago/4G-5G-through-SDR/wiki/Programmation-de-la-carte-SIM) d'une carte SIM programable et configuration d'une APN sur un téléphone
