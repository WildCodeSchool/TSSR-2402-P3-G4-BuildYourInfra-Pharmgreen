
Afin d'inventorier les machines présentes sur le domaine, il faut installer glpi-agent sur chaque machine : 

- Pour Debian :

`wget https://github.com/glpi-project/glpi-agent/releases/download/1.8/glpi-agent-1.8-linux-installer.pl`

Ensuite celle-ci : 

`perl glpi-agent-1.8-linux-installer.pl` 

Renseigner l'adresse de votre serveur GLPI (ici `http://192.168.9.6`), 2 fois `Entrée`.
