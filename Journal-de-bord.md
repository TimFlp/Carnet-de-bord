# Carnet de bord individuel pour la SAE 21 :
## <u> Sommaire :</u>
* ### [Conception Réseau](#uconception-et-dessin-du-schéma-du-réseau-final-u)
* ### [Configuration Serveur Web](#uconfiguration-serveur-web-u)
* ### [Configuration Routeur,Vlan,DHCP](#urouteurvlandhcp--u)
* ### [Création de Dockers Debian](#uconfiguration-des-machines-avec-docker-u)
* ### [Création Access-lists](#ules-access-list-aclu)
* ### [Configuration service DNS](#uconfiguration-dns-u)
* ### [Configuration NAT partie virtualisée](#uconfiguration-du-nat-u)

----- 

## <u>**Conception et dessin du schéma du réseau final :**</u>

### *Le plus important avant de commencer quoi que ce soit de concret pour la réalisation du réseau de l'entreprise, il faut faire un plan. Il faut donc réfléchir sur quel réseau nous allons placer nos 3 zones distinctes, combien il y aura de machines en total, en bref avoir une vue concrète pour nous simplifier la vie et ne pas partir dans tout les sens.*    <br>     
<br>

### Pour cela j'ai donc utiliser l'extension Draw.io disponible sur VisualStudio et j'ai pu réaliser ce schéma-ci : 
<br>

![schéma](https://github.com/TimFlp/Carnet-de-bord/blob/master/assets/sch%C3%A9m2.png)

<br>

### Il y aura donc dans notre réseau d'entreprise 3 zones distinctes : <br> 
<br>

### - La partie réseau entreprise en bleu qui sera virtualisé, avec un serveur Web, les différents répartissements du réseau entre chaque branches du réseau (Administratifs, etc...), tous répartis dans des Vlan **pour plus de sécurité**. **J'ai également choisi un réseau en /16** pour plus de flexibilité et pouvoir adresser les machines sous la forme : **192.168.Vlan.Machine**. J'ai placé un switch par Vlan pour faciliter la mise en place de celles-ci (Un port du switch principal servira pour tout le Vlan10 et ainsi de suite...) mais également pour faciliter l'agrandissement possible dans le futur du matériel informatique. Ainsi, si on souhaite rajouter une machine, il suffira simplement de la relier au switch correspondant à son Vlan.
<br> 

### - Il y a également la DMZ, la partie physique du réseau (en orange au centre) que nous allons réaliser avec un routeur Mikrotik qui fera également office de pare-feu, un switch puis une machine qui servira de DNS ainsi que de serveur Web. **J'ai choisi un plan d'adressage en /29** également pour des raisons de **sécurité** pour ne pas qu'une machine étrangère au réseau puisse se connecter. Nous avons utiliser un routeur Mikrotik car nous en avions beaucoup à disposition mais surtout parcequ'il est très polyvalent, il peut quasiment tout faire pour une taille très réduite. Egalement, nous connaissions déjà certaines manipulations sur ces routeurs donc nous serions directement plus à l'aise.
<br>

### - Finalement, il y a le réseau de l'IUT en rouge, que nous gérons pas et qui est adressé en 10.214.0.0/16

------

## <u>**(Configuration serveur web)** </u>
<br>

### Pour les différents serveurs Web, j'ai choisi d'utiliser le module apache2 disponible sur Debian car il est très simple et rapide à mettre en place mais aussi parce-que nous avons fait plusieurs TP dessus.

### J'ai également réalisé une mini page Web simple en HTML/CSS pour avoir quelque chose à afficher sur nos serveurs : 
<br>

![preview](assets/web.JPG)
*Tous les codes sont dans le dossier configuration.*
<br>

### Pour pouvoir **mettre en place le service apache2** sur une machine **Linux** et en respectant les règles basiques de sécurité, il faut suivre une procédure très simple :
<br>  

### Tout d'abord, il faut nettoyer la machine :

    sudo rm -rf /etc/apache2 && sudo rm -rf /var/www/html/
    sudo apt purge -y apache2 && sudo apt autoremove

### Installation package apache2 :

    sudo apt install apache2 

### Pour inclure le code de la page du serveur web interne : 

    echo "<html><head><meta charset="utf-8"><title>Site Web Interne</title></head><body><style>html {background-color:beige}</style><h1>Wouhou รงa marche</h1><h4>Site web interne</h4></body></html>" > /var/www/html/index.html

### Lancer le service : 

    sudo service apache2 start

### Vérifier le statut : 

    sudo service apache2 status

-----

## <u>**(Routeur,Vlan,DHCP) :** </u>
<br>

### Je me suis occupé également des différents switchs et routeur Cisco que nous aurons dans le réseau final. J'ai donc écrit un petit mémo pour pouvoir configurer rapidement les différentes interfaces du routeur, puis pour la configuration des vlan ainsi que le DHCP. 
***J'ai placé mes commandes finales dans le dossier Compte-rendu***
<br>    

## <u>Configuration interfaces</u> 
    Routeur# configure terminal   # Pour entrer en mode configuration

### Adressage IP :
    Routeur(config)# interface <nom de l'interface>   # Préciser l'interface
  
    Routeur(config)# ip address <IP> <masque en octal>     # Adressage

    Routeur(config)# no shutdown     # Pour allumer l'interface 

    Routeur(config)# end    # Pour revenir 

### Pour rajouter une route par défaut : 
    Routeur(config)# ip route 0.0.0.0 0.0.0.0 <IP route par défaut>

### Pour vérifier sa configuration : 
    Routeur# show run

        / ou /

    Routeur# show run <interface>  
    # Pour regarder spécifiquement la configuration d'une interface

### Pour désactiver la configuration par Internet (**Pour des mesures de sécurité**) 

    Routeur(config)# no ip http server    
    Routeur(config)# no ip http secure-server

### Pour sécuriser l'accès à la configuration : 
     Routeur(config)# service password-encryption

### Pour changer le mot de passe par défaut d'admin : 
    routeur(config)# username admin password 0 M0t_D3-P4sS3

***On peut aller plus loin dans la sécurisation en désactivant la connexion ou en régulant les nombres de tentatives en Telnet, ssh...***

## <u>Configuration VLAN :</u>
<br>

### **Pour ce qui est des VLAN, GNS3 nous propose une interface graphique simple pour configurer le Switch principal :**
<br>

**METTRE PHOTOS**

 ***Il faut noter que l'appelation 'trunk' comme nous avons sur les switchs cisco de base, se nomme ici dot1q, c'est un nom différent mais qui ont la même utilité. On choisis donc ce mode là pour la liaison SwitchPrincipal -> Routeur***

<br>

### Après avoir fait cela, nous relions les switchs à chaque ports dont ils sont destinés et **il faut ensuite régler les Vlan au niveau du routeur** car c'est lui qui se chargera de retransmettre à chaque fois les paquets.

<br>

### La configuration du routeur se fait assez classiquement. Nous déclarons à chaque fois **une sous-interface par Vlan** puis nous déclarons le numéro de vlan qui sera encapsulé sur chaque paquets puis finalement nous mettons une adresse IP qui sera **l'adresse de la passerelle par défaut du Vlan**.
<br>

    interface FastEthernet1/0.10  // On déclare la sous-interface
    encapsulation dot1Q 10   // On déclare l'encapsulation sous le VLANID : 10
    ip address 192.168.10.254 255.255.255.0    // Adresse de la passerelle par défaut du VLAN
    no shutdown  // Pour activer la sous-interface   
    end   // Revenir au menu d'entrée du routeur
    wr   // Pour inscrire les modifications dans la mémoire du routeur

***Nous devons donc répéter l'action 3 fois pour les 4 Vlan***

## **Finalement, il reste à configurer le service DHCP sur le routeur :**
<br>

### J'ai choisi de placer **le service DHCP sur le routeur** pour éviter des conflits entre mes futures Access-list et rendre le processus plus rapide que par une machine qui devrait traverser un premier Vlan puis par le routeur et ainsi de suite... 

### Pour simplifier la vie du service informatique lorsqu'il faudra savoir quelle machine appartient à qui et ainsi de suite, j'ai choisi de configurer mon service **DHCP en fonction des adresses MAC** pour que chaque machines aient la même adresse à chaque démarrage.

### Egalement, il s'agit d'une mesure de sécurité puisqu'une machine malveillante ne pourra pas demander de configuration au service DHCP puisqu'il n'est pas inscrit avec son adresse MAC. Cependant ce n'est pas magique, il peut comprendre comment fonctionne le réseau et ainsi s'adresse comme il le faut ou bien encore **spoofer** l'adresse mac d'une machine inscrite dans la configuration.
<br>

### **Configuration :**

### Il faut tout d'abord inscrire les adresses que le service dhcp ne pourra pas attribuer car elles sont déjà prises d'emblée :

    ip dhcp excluded-address 192.168.10.254  // IP passerelle VLAN10
    ip dhcp excluded-address 192.168.20.254   // IP passerelle VLAN20
    ip dhcp excluded-address 192.168.30.254   // IP passerelle VLAN30
    ip dhcp excluded-address 192.168.40.254   // IP passerelle VLAN40

### Finalement, on doit créer un *dhcp pool* **pour chaque machine** puisqu'on agit **en fonction des adresses MAC** : 

    ip dhcp pool pc3   // Création d'un pool avec comme nom 'pc3'
    host 192.168.10.1 255.255.255.0   // L'adresse IP que l'hôte va recevoir
    hardware-address 0042.3833.3333   // Inscription de l'adresse mac de la machine, convention CISCO : 00:42:38:33:33:33 -> 0042.3833.3333
    default-router 192.168.10.254    // Passerelle par défaut qui lui sera fourni
    dns-server 172.16.0.2    // Adresse du serveur DNS qui lui sera fourni

### Et ce, pour chacunes des machines du réseau. ***Comme toujours, la configuration est trouvable dans le dossier Compte-rendu.***

### **TroubleShooting :**
***Pour vérifier notre configuration***

    show ip dhcp binding    // Afficher les bails en cours

    show ip dhcp pool     // Afficher les pools adressables du service


------
## <u>**Configuration des machines avec Docker :**</u> 

![docker_vie](assets/docker.png)

### Au début du projet, j'avais utiliser pour GNS3 les images que nous avions utiliser lors des précédents TPs de la ressource R201. Cependant, je me suis vite rendu compte que les configurations que je faisais dessus étaient perdues...
<br>

### J'ai donc d'abord cherché comment mettre en place un volume persistant pour les dockers puis au bout d'une semaine infructueuse j'ai décidé de me renseigner sur la création de **Docker**. De plus, c'est une techno qui m'intéressait donc je ne perdais rien à le faire.

## **Réalisation :** 

### J'ai tout d'abord créer un container **Debian** simple avec simplement des outils pour faire des actions de réseaux simples comme curl ou alors ping, mais j'ai eu un problème. Peut importe mes paramètres de lancement, **je n'arrivais pas à conserver une adresse MAC stable**, qui était le point le plus important à conserver pour mes dockers. 
<br>

### Je me suis donc renseigné et **j'ai choisi de placer un script bash personnalisé** pour chacuns de mes dockers. Ce script bash permettait de placer d'une part **une adresse mac personnalisée** avec **ip link** ainsi que d'**activer le service ssh** sur chacunes des machines pour le service informatique. Finalement, le script sert aussi à faire une requête automatique vers le service DHCP du routeur.

## **Mon bash :**

    #!/bin/sh

    ip link set eth0 down     
    ip link set eth0 address 00:42:38:11:11:11   # Mise en place de la MAC 
    ip link set eth0 up
    dhclient eth0   # Requête DHCP
    service ssh start  # Mise en place SSH
    echo "PasswordAuthentication yes" >> /etc/ssh/ssh_config
    echo "Port 22" >> /etc/ssh/sshd_config
    echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
    echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config
    useradd -d /home/pc1-ssh -p password test  # Création utilisateur pour SSH
<u>***Bash pour le PC-1***</u>

## **Mon dockerfile :**

    # Récupère la dernière version de debian possible, plus sécurisé (théoriquement)
    FROM debian:latest

    #Installation des dépendances
    RUN apt-get update -y \
        && apt-get upgrade -y \
        && apt-get install -y apt-utils \
        && apt-get install -y iproute2 \
        && apt-get install -y net-tools \
        && apt-get install -y iputils-ping \
        && apt-get install -y isc-dhcp-client \
        && apt-get install -y nano \
        && apt-get install -y openssh-server \
        && apt-get install -y openssh-client \
        && apt-get install -y sudo \
        && apt-get install -y iptables \
        && apt-get install -y curl

    WORKDIR /home/pc1  # Met en place le répertoire de travail pour pc1
    ADD mac.sh /home/pc1/mac.sh     # Ajoute dans le nouveau répertoire notre fichier bash inclus dans le dossier avec le docker
    RUN chmod 700 /home/pc1/mac.sh  # Rajoute les droits aux fichier bash pour qu'il puisse être executé
<u>***Dockerfile du PC1***</u>

### Au final, j'ai donc mes dockers qui seront mes pc et que je placerais dans mon montage GNS3, j'aurai juste alors à démarrer sur chacunes des machines le script à chaque relancement. J'aurai voulu que cela se fasse automatiquement au démarrage mais après plusieurs tests je n'ai jamais réussi.

------

## <u>**Les Access-list (ACL)**</u>
<br>

### C'est l'une des dernières choses que j'ai réalisé et qui m'a sûrement pris le plus de temps pour que tout fonctionne.
### Notamment car il y avait beaucoup de critères à respecter comme le fait de ne pas pouvoir communiquer entre Vlan mais la possibilitée d'établir une connexion SSH avec comme source le Service Informatique et ainsi de suite.

<br>

### Avant d'écrire quoi que ce soit, j'ai réfléchis à quels ports étaient importants ou non pour pouvoir ensuite bloquer tout les autres ainsi que les adresses qui pouvaient communiquer ou non entre elles :

<br>

### <u>Ce qui a donné :</u> 
* ### Autoriser les ports tcp 80 et 443 pour aller visiter des sites Web
* ### Autoriser les ports udp 67 et 68 pour le service Dhclient
* ### Autoriser le port 22 ayant pour source les adresses du service informatique
* ### Autoriser n'importe quel port tcp si la communication a été initialisié par le port 80 ou 443
* ### Accepter le protocole ICMP (ping) si il n'est pas à destination d'un Vlan dont il n'a pas le droit de communiquer.
* ### Refuser tout le reste et loguer tout ce qui a été refusé

<br>

### Et cela a donné par exemple pour le Vlan40 ces règles : 

    VLAN 40 : 
    ip access-list extended VLAN40
    permit udp any any eq 67
    permit udp any any eq 68
    permit icmp any any
    permit tcp 192.168.40.0 0.0.0.255 192.168.10.0 0.0.0.255 
    permit tcp 192.168.40.0 0.0.0.255 192.168.20.0 0.0.0.255
    permit tcp 192.168.40.0 0.0.0.255 192.168.30.0 0.0.0.255
    permit ip host 192.168.255.254 any
    deny ip any any log

### Pour finir, il ne faut pas oublier d'appliquer ces règles aux bons Vlan et donc aux bonnes sous-interfaces :

<br>

    interface FastEthernet0/1.40
    ip access-group VLAN40 in   # Pour établir les règles pour les connexions entrantes
    ip access-group VLAN40 out  # Pour établir les règles pour les connexions sortantes
***Comme toujours, les configurations complètes des ACL sont présentes dans le dossier Compte-rendu.***

-----
## <u>**Configuration DNS :**</u>

![bind](assets/bind.png)

### ***Pour être honnête, je n'ai pas vraiment approfondi mon travail sur le DNS car je ne devais pas le faire de base. J'ai pu quand même faire les réglages de bases mais j'imagine que niveau sécurité ce n'est pas le top et je compte m'y pencher pendant les vacances.***

<br>

### Pour le service DNS qui est présent dans la DMZ, j'ai choisi le package Bind9 qui est simple d'utilisation et qui nous a été recommandé.

### J'ai donc pu écrire un manuel qui me permet de refaire les manipulations autant de fois que nécessaires :

    Nettoyer la machine des précédentes configurations :

    sudo rm -rf /etc/bind && sudo rm -rf /var/cache/bind
    sudo apt purge -y bind9 dnsutils && sudo apt autoremove

    Installation paquets importants :

    sudo apt install bind9 dnsutils 

    Instructions : 

    sudo cp /etc/bind/db.local /etc/bind/Rtequila
    sudo cp /etc/bind/db.local /etc/bind/Inverse

        1) Modifier le fichier named.conf : 
            nano named.conf

    include "/etc/bind/named.conf.options";
    include "/etc/bind/named.conf.local";
    include "/etc/bind/named.conf.default-zones";

    zone "Rtequila" IN {
            type master;
            file "/etc/bind/Rtequila";
            forwarders 8.8.8.8;
            forwarder-only;
    };

    zone "2.0.16.172.in-addr.arpa." IN {
            type master;
            file "/etc/bind/inverse";
            forwarders 8.8.8.8;
            forwarder-only;
    };


        2) Modifier le fichier Rtequila : 
        
    ;
    ; BIND data file for local loopback interface
    ;
    $TTL    604800
    @       IN      SOA     server1.Rtequila. root.Rtequila. (
                                2         ; Serial
                            604800         ; Refresh
                            86400         ; Retry
                            2419200         ; Expire
                            604800 )       ; Negative Cache TTL
    ;
    @       IN      NS      server1.Rtequila.
    server1 IN      A       172.16.0.2
    www     IN      CNAME   server1.Rtequila.


        3) Modifier le fichier Inverse :
        
    ;
    ; BIND data file for local loopback interface
    ;
    $TTL    604800
    @       IN      SOA     server1.Rtequila. root.Rtequila. (
                                2         ; Serial
                            604800         ; Refresh
                            86400         ; Retry
                            2419200         ; Expire
                            604800 )       ; Negative Cache TTL
    ;
    @       IN      NS      server1.Rtequila.
    server1 IN      A       172.16.0.2
    1       IN      PTR     server1.Rtequila.


    Changer son service dns : 

    nano /etc/resolv.conf
    nameserver 172.16.0.2

    Lancer le service : 

    sudo service bind9 start

    Vérifier le statut : 

    sudo service bind9 status

### **Pour tester ma configuration, je peux faire différents tests avec l'utilitaire nslookup ou bien dig**

    nslookup
        > set type=<type>    ( On peut mettre NS, A, MX... )
        > <IP serveur>

### Pour dig : 

    dig -t type Rtequila

----

## <u>**Configuration du NAT :**</u>

### Enfin, ma dernière partie de travail était de mettre en place le NAT de mes adresses privées vers celles de la DMZ, pour transmettre finalement mes paquets sur Internet.

<br>

### **Illustration du fonctionnement :** 

<br>

![nat](assets/nat.JPG)

### Pour le NAT, j'ai choisi de faire en sorte que **chaque VLAN ait une adresse unique natté sur le réseau de la DMZ** :

| Numéro VLAN  | Adresse VLAN       | Adresse natté |
| :--------------- |:---------------:| -----:|
| 10  |   192.168.10.0/24       |  172.16.0.4/29 |
| 20  | 192.168.20.0/24            |   172.16.0.5/29 |
| 30  | 192.168.30.0/24        |    172.16.0.6/29 |

### Comme cela, **on rajoute une couche de sécurité** et le **Vlan40 ne pourra jamais voyager plus haut que le réseau virtualisé sous Gns3**.

<br>

## <u>Pour ce faire sur le routeur, on entre les commandes suivantes :</u>

### On établit tout d'abord sur chaque sous-interfaces l'IP natté qu'on va attribué au VLAN (ici le VLAN10) :

    interface FastEthernet0/0.10    # On définit la sous interface

    ip nat pool POOL-VLAN10 172.16.0.4 172.16.0.4 netmask 255.255.255.248    # On indique l'adresse natté

    access-list 10 permit 192.168.10.0 0.0.0.255   # On définit le fait que seulement les adresses du VLAN10 sous la forme 192.168.10.0/24 pourront emprunter cette adresse.

    ip nat inside source list 10 pool POOL-VLAN10 overload # On indique qu'on natte l'adresse d'une patte interne vers une patte externe. L'argument overload indique que plusieurs machines peuvent être nattés sous la même adresse.

### ***Il faut donc réaliser cela pour les deux autres VLAN***

<br>

### Finalement, il ne faut pas oublier d'adresser sur la patte externe du routeur les adresses qui pourront êtres nattés sur son interface FastEthernet0/0 ( celle présente dans la DMZ ) :

<br>

    conf t
    interface FastEthernet0/0
    ip address 172.16.0.4 255.255.255.248 secondary  # Adressage classique mais avec argument secondary pour indiquer au routeur qu'on met plusieurs adresses sur la même interface, ce qui est théoriquement infaisable de base.
    
    ip address 172.16.0.5 255.255.255.248 secondary
    ip address 172.16.0.6 255.255.255.248 secondary
    ip nat inside
    end
    write mem