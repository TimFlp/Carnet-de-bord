SAE21-Construire-un-réseau-informatique-pour-une-petite-structure
=============================================

## Contexte pédagogique

* Le travail sera réalisé en groupe de 3 étudiants. Les groupes vous seront fournis par tirage au sort. Un rendu collectif ET un rendu individuel seront exigés en fin de SAE. Des évaluations intermédiaires seront réalisées sur des points particuliers tout au long de la SAE par les encadrants.

## Contexte professionnel

* Le professionnel R&T peut être sollicité pour construire et mettre en place le réseau informatique d'une « petite » entreprise multi-sites. L'objectif est alors de répondre aux besoins de commutation, de routage, de services réseaux de base et de sécurité formulés pour la structure. Ce réseau s'appuie
sur des équipements et des services informatiques incontournables mais fondamentaux pour fournir à la structure un réseau fonctionnel et structuré.

* Spécificité de mise en œuvre de la SAE :

    Afin de limiter le nombre de machines à utiliser pour cette SAE, on divisera de façon artificielle le réseau en 2 parties : une première physique qui assurera l’interconnexion avec internet (représenté par le réseau de l’IUT) et la DMZ. Cette dernière sera interfacée avec une seconde partie émulée correspondant au réseau LAN de l’entreprise. Le LAN comprendra un serveur WEB pour l’Intranet ainsi que les postes client des différents services. Le schéma de principe est donné sur la figure 1.

## Matériels à notre disposition

* Switchs cisco
* Routeurs microtic
* Ordinateurs des salles de TP réseaux

## Logiciels à disposition

* Logiciel de simulation de réseau (Packettracer / GNS3 /…)
* Github

## Cahier des charges

La petite entreprise pour laquelle vous travaillez souhaite mettre en place son réseau d’entreprise.

* Dans un premier temps vous choisirez un nom pour cette entreprise (cela sera utile plus tard pour la partie DNS).

* Vous devrez prévoir le plan d’adressage de toutes les machines.

* Au niveau de la structure de l’entreprise, on retrouve 3 services, les administratifs qui travaillent dans les locaux de l’entreprise, les commerciaux qui peuvent être amenés à voyager en dehors des murs de l’entreprise et le SI (service informatique) qui doit gérer le réseau et les serveurs.

* L’entreprise souhaite avoir un serveur web externe qui contiendra une simple page html statique avec le nom de l’entreprise. Ce serveur sera placé dans la DMZ et sera accessible à la fois pour les personnes à l’intérieur du réseau comme pour celle à l’extérieur du réseau (partie IUT).

* Un serveur DNS sera également placé en DMZ. Vous configurerez le serveur DNS de l’entreprise pour qu’il assure la résolution des noms symboliques des serveurs web et qu’il redirige les résolutions qu’il n’arrive pas à faire vers un serveur externe.

* Un serveur Web interne (servant à l’intranet) ne sera accessible que pour les
utilisateurs du réseau.

* Vous déploierez un serveur DHCP qui fournira à toutes les machine du LAN leurs adresses IP.

* On souhaite mettre un peu de sécurité et limiter les échanges entre les différents services, il vous faudra proposer une solution.

* Au niveau des accès :
    
    * les administratifs devront pouvoir accéder à internet et aux serveurs internes et externe.

    * Les commerciaux devront pouvoir accéder aux serveurs interne et externes.

    * Le SI doit pouvoir avoir accès à toutes les machines en SSH.

    * Aucun message provenant de l’internet ne doit pouvoir arriver vers le LAN. Par contre il peuvent atteindre le serveur web externe.
