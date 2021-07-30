# LinuxProject

Ce projet consiste en une gestion et description de données d'un serveur de comptes. <br />
Deux machines M1 et M2. La machine M1 constitue la machine de travail et M2 celle de sauvegarde (tout y est transféré dans le dossier /backup2 de l'utilisateur save).

<img width="428" alt="projet" src="https://user-images.githubusercontent.com/53021621/127621137-3a901045-2124-4a7b-8bc9-9d7bcfbb72ea.png">

## Script

Les comptes utilisateurs définis sur la machine M1 à travers le fichier système /etc/passwd sont récupérés au format XML, archivés au format TGZ, inscrit dans une base de données SQL et ensuite envoyés via SCP à la machine M2. Tous les scripts sont égalements envoyés à la machine M2. 

Les comptes sont stockés selon le format suivant : 
```
<?xml version="1.0"?>
<users>
   <user>
      <name>root</name>
      <uid>0</uid>
      <gid>0</gid>
      <home>/root</home>
      <shell>/bin/bash</shell>
      <taille>987564</taille>
      <fingerprint>c0e9eb4ee47a763f962567c58be8eca1</fingerprint>
   </user>
   <user>
      <name>enzo</name>
      <uid>1100</uid>
      <gid>1100</gid>
      <home>/home/enzo</home>
      <shell>/bin/bash</shell>
      <taille>754321</taille>
      <fingerprint>ace7a078fdb56db43a654cc7fbaf283f</fingerprint>
   </user>
   ...
</users>
```

Une authentification ssh automatisée par clé RSA a été mise en place. 
```bash
ssh-keygen -t rsa -b 4096
ssh-copy-id user@domain
```

Le script de gestion des utilisateurs a été automatisé via crontab tous les jours à 23:00.

## Vagrant

Pour permettre la création d'une machine virtuelle à la demande. On créé un Vagrantfile permettant de cloner la machine M1 dans le cas d'un crash à partir des scripts sauvegardés sur la machine M2.

### Installation 

Installer la dernière version de Vagrant ainsi que de VirtualBox (https://www.vagrantup.com/downloads & https://www.virtualbox.org/wiki/Downloads)

Pour les utilisateurs Windows, 2 choses sont également à faire/vérifier : 

* Désactiver "Plateforme de l'hyperviseur Windows" depuis "Activer ou désactiver des fonctionnalités Windows"
* Activer option "Intel Virtualisation Technology" depuis le BIOS

### Vagrantfile

Une fois déplacé dans le dossier où se trouve le Vagrantfile, on peut lancer la construction de notre vm avec la commande suivante : 
* ``` vagrant up ``` 

Pour chaque modification effectuée dans le fichier de configuration, bien penser à éxécuter : 
* ``` vagrant reload --provision ```

### A faire 

Changer la langue du clavier en FR depuis le Vagrantfile
