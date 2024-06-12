1) Installation de CloneZilla

2) Installation de win-exporter

3) Installation de node_exporter

4) Création de conteneur grafana et prometheus

## 1. Instalation de CLoneZilla

### liste des paquets a installer

- executer cette commande `apt install rsync gawk gnupg curl`

### ajout du depot DRBL

- `curl -s https://drbl.org/GPG-KEY-DRBL | gpg --no-default-keyring --keyring gnupg-ring:/etc/apt/trusted.gpg.d/GPG-KEY-DRBL.gpg --import`

- executer cette commande `chmod 644 /etc/apt/trusted.gpg.d/GPG-KEY-DRBL.gpg`

- Ajout du depot DRBL dans sources.list : `echo "deb http://free.nchc.org.tw/drbl-core drbl stable" >> /etc/apt/sources.list`


### installer le paquet DRBL

- faire `apt update`
- pour installer executer la commande apt-get install drbl

### configuration

- executer la commane `drbldrv -i`

![image](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/81968235/f44cdfc1-e2bc-49cd-831f-8893b74ff39e)


- appuyer sur entrée

![image](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/81968235/294a2e3a-5a2d-435b-ae53-a4aa693653a8)


- appuyer sur entrée

![image](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/81968235/42971194-691b-41e9-a5c9-84f0338802ef)


- appuyer sur entrée

![image](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/81968235/5a2452db-0855-4b68-988f-5dadd06d3b04)


- appuyer sur entrée

- executer la commande `drblpush -i`

![image](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/81968235/dd8baf9b-c6e2-4cea-9d61-cc1b46c5a57d)


- rentrer le nom de domaine : **pharmgreen.org**
- appuyer sur entré

![image](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/81968235/04c04d06-5875-4c38-813a-9355639085ba)


- appuyer sur entré

![image](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/81968235/6a7d79c5-00c3-4760-b66c-eac60bd949ff)


- appuyer sur entré
  
![image](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/81968235/a7d07ed4-7d89-4295-87ab-6b7c015a9893)


- appuyer sur entré

![image](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/81968235/d5ca68fd-8f8e-4fff-b5d3-21fad0992e61)


- appuyer sur entré

![image](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/81968235/5ce9cc0e-7f37-4a98-88b4-2b895a58c3fe)


- reponse : N

![image](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/81968235/8d299f54-51e9-4f94-ac4b-d63bbdb4f940)


- appuyer sur entré

![image](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/81968235/e06d9d0c-0543-4228-8900-62359fe7b03c)


- mettre 2 qui correspond au dernier octet de l'adresse ip 

![image](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/81968235/bee541ae-bacd-4a9d-8475-16593417a5e1)


- mettre 20(le serveur va pouvoir acceder de l'adresse x.x.x.2 a x.x.x.21)

![image](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/81968235/d259f965-5537-4162-ad70-0ef77621b660)


- apuyer sur entré
- le resultat devrais etre :

![image](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/81968235/ee794771-be4e-4fcc-8afb-983c4d4845b6)


- appuyer sur entré

![image](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/81968235/c80eac16-6a7a-4b02-af4b-b5c98580f6d6)


- appuyer sur entré

![image](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/81968235/b258beb9-2e5d-4e68-94f4-07da3b4bb335)


- appuyer sur entré

![image](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/81968235/2a93095a-6413-4333-b45c-4773730a96b3)


- appuyer sur entré (Les clones seront stocker dans /home/partimag)

![image](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/81968235/18890d9b-2712-4669-bffe-6cb6eec37be9)


- appuyer sur entré

![image](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/81968235/acaac5dc-4c68-4549-85f2-85c8f82a744f)


- appuyer sur entré

![image](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/81968235/56507bc6-2aaa-44b4-8e3a-0ba14af5f495)


- appuyer sur entré

![image](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/81968235/ffbcd8fe-3272-4907-84a5-bf1790b17596)

- appuyer sur entré

![image](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/81968235/a2c0971d-049f-4cd5-9744-addfbfc3a09c)


- appuyer sur entré

![image](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/81968235/71117698-4bd3-4239-9936-d7f8a2fc6af0)


- appuyer sur entré

![image](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/81968235/13c7e062-d7dc-4871-bf01-c3cf79109dcd)


- appuyer sur entré

![image](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/81968235/94200716-183f-417b-aecd-7a6fd1ace195)


- appuyer sur entré

![image](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/81968235/7eb9dcb1-ccba-4e6a-980f-728858832355)

- appuyer sur entré

![image](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/81968235/55b3abd4-bbe1-443f-b1a2-d4aa6873f4b1)


- appuyer sur entré

![image](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/81968235/63c68361-9c1b-450a-8db8-6de7641ebdda)


- appuyer sur entré

![image](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/81968235/2719ecc3-9b24-4456-8ed7-32803188f24c)


- appuyer sur entré

![image](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/81968235/7cc145fa-4d92-4b97-bad3-cd28939b9995)

- reponse : N

!![image](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/81968235/0d3e902b-e494-4a8a-b750-93d348f96691)

- appuyer sur entré

![image](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/81968235/c8b2daee-1cdd-4b34-98b7-dee1988fae7c)

- appuyer sur entré

- executer la commande `dcs`

![image](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/81968235/1b7f0f44-0304-48ac-bfde-0d4941b55a46)

- choisir la premiere option

![image](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/81968235/b644a69b-1adf-44dc-a772-cd43dbb1bdac)

- choisir **clonezilla-start**

![image](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/81968235/1e07e369-7a32-458c-a4dd-03d18ab0628b)

- choisir le mode **Beginner**

![image](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/81968235/e182dbff-5f0e-494c-825d-18f6fac57696)

- choisir **select-in-client**

![image](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/81968235/a6a70084-bd32-4f9f-be3c-c4d55b3e5fbd)

- choisir la premiere option

![image](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/81968235/b0c0c1f4-1ec0-4d82-a66b-2c8300a3db3b)

- choisir **poweroff**

## 2. Installation de win-exporter

Pour la supervision, nous sommes passés par `Grafana` et plus particulièrement par `Prometheus` pour récupérer les donneés des machines.

Afin de récupérer les données des machines Windows, nous avons dabord dû installer `Chocolatey`, pour cela il faut exécuter la commande suivante dans PowerShell :

`Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))`.

Ensuite il faut installer `win-expoter` de cette manière : `choco install prometheus-wmi-exporter.install`.

![image](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/161329881/ff1d2263-a267-4d67-a48e-4e0bbe639204)

C'est tout pour la partie client, il faut maintenant configurer Prometheus directement sur le serveur Prometheus dans le fichier `/etc/prometheus/prometheus.yml` et y mettre les infos suivantes :

![image](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/161329881/8b7cbac5-3bf1-4156-96b7-9575c22eae47)

Explications : 
- il faut d'abord créer un job "win-exporter"
- et ensuite sous `static configs` préciser les adresses des machines windows que l'on veut monitorer et donc ici : `192.168.9.5:9182` et `172.16.3.3:9182`.

Une fois tout cela fait, redémarrer le service. Quand vous allez sur l'interface web, vous verrez ceci :

![image](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/161329881/382294f7-eba6-4f56-a4b4-dd7bdeca5aa8)




# Guide d'Utilisateur pour Prometheus et Grafana avec Docker


## Étapes de Configuration

  ### Télécharger les Images Docker

`docker pull prom/prometheus`

`docker pull grafana/grafana`

#### Lancer le Conteneur Prometheus

`docker run --name prometheus -d -p 127.0.0.1:9090:9090 prom/prometheus`

Cela lance un conteneur Prometheus qui sera accessible localement à l'adresse http://localhost:9090.

#### Lancer le Conteneur Grafana

`docker run -d --name=grafana -p 3000:3000 grafana/grafana`

Cela lance un conteneur Grafana qui sera accessible localement à l'adresse http://localhost:3000.



