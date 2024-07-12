Sommaire :

1. Installation client OpenVPN

2. Installation 
   
3. Installation 

 
 
 # 1. Installation Client OpenVPN

## Pré-requis

- Avoir le certificat d’autorité (CA) du serveur
- Avoir le certificat et la clé du serveur
- Avoir la clé TLS du serveur

## Configuration du Client SSL/TLS

### Importer le CA et le Certificat

Sur le client, importer le certificat CA ainsi que le certificat et la clé du client pour ce site. Il s'agit du même certificat CA et du certificat client créés précédemment.

### Importer le CA

1. Aller à **System > Certificates**, onglet **Authorities**
2. Cliquer sur **Add** pour créer une nouvelle autorité de certification
3. Entrer les paramètres suivants :
   - Nom descriptif : `openvpnekogreen`
   - Méthode : `Import an existing Certificate Authority`
   - Données du certificat : Ouvrir le fichier du certificat CA dans un éditeur de texte sur le PC client, sélectionner tout le texte, et le copier dans le presse-papiers. Puis le coller dans ce champ.
4. Cliquer sur **Save**

### Importer le certificat du client

1. Aller à **System > Certificates**, onglet **Certificates**
2. Cliquer sur **Add** pour créer un nouveau certificat
3. Entrer les paramètres suivants :
   - Méthode : `Import an existing Certificate`
   - Nom descriptif : `clientB VPN Certificate`
   - Type de certificat : `X.509 (PEM)`
   - Données du certificat : Ouvrir le fichier du certificat client dans un éditeur de texte sur le PC client, sélectionner tout le texte, et le copier dans le presse-papiers. Puis le coller dans ce champ.
   - Données de la clé privée : Ouvrir la clé privée du certificat client dans un éditeur de texte sur le PC client, sélectionner tout le texte, et le copier dans le presse-papiers. Puis le coller dans ce champ.
4. Cliquer sur **Save**

Répétez ces étapes sur chaque pare-feu client.

## Configurer l'Instance Client OpenVPN

Après avoir importé les certificats, créer le client OpenVPN :

1. Aller à **VPN > OpenVPN**, onglet **Clients**
2. Cliquer sur **Add** pour créer un nouveau client
3. Remplir les champs comme suit, en laissant tout le reste par défaut :
   - Description : Texte pour décrire la connexion (par ex. `OPENVPNekogrenn`)
   - Mode Serveur : `Peer to Peer (SSL/TLS)
   - Mode Appareil : `tun`
   - Protocole : `UDP on IPv4 only`
   - Interface : `WAN`
   - Hôte ou adresse du serveur : L'adresse IP publique ou le nom d'hôte du serveur OpenVPN (par ex. `198.168.0.254`)
   - Port du serveur : `1194`
   - Utiliser une clé TLS : Coché
   - Générer automatiquement une clé TLS : Non coché
   - Clé TLS : Coller la clé TLS copiée depuis l'instance serveur
   - Autorité de certification du pair : Le CA importé au début de ce processus
   - Certificat client : Le certificat client importé au début de ce processus
4. Cliquer sur **Save**

**Note :** Avec les configurations SSL/TLS serveur/client comme cet exemple, les routes et autres options de configuration sont automatiquement poussées depuis le serveur et ne sont donc pas présentes dans la configuration du client.

## Règles de Pare-feu

Une règle de type "Autoriser tout".

### Exemple de règle pour autoriser tout le trafic :

1. Aller à **Firewall > Rules**, onglet **OpenVPN**
2. Cliquer sur **Add** pour créer une nouvelle règle en haut de la liste
3. Configurer les options comme suit :
   - Protocole : `any`
   - Source : `any`
   - Description : `Allow all on OpenVPN`
4. Cliquer sur **Save**
5. Cliquer sur **Apply Changes**

Votre configuration Client OpenVPN est maintenant terminée.
