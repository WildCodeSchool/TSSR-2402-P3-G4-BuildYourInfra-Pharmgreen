
# Guide d'Utilisateur pour Prometheus et Grafana avec Docker

## Sommaire
1. [Étapes de Configuration](#étapes-de-configuration)
    1. [Télécharger les Images Docker](#1-télécharger-les-images-docker)
    2. [Lancer le Conteneur Prometheus](#2-lancer-le-conteneur-prometheus)
    3. [Lancer le Conteneur Grafana](#3-lancer-le-conteneur-grafana)
2. [Installation de win-exporter](#4-installation-de-win-exporter)
3. [Installer Node Exporter et ajouter à Prometheus](#5-installer-node-exporter-et-ajouter-à-prometheus)
    1. [A quoi sert Node Exporter ?](#a-quoi-sert-node-exporter-)
    2. [Installation](#installation)
        1. [Téléchargement](#téléchargement)
        2. [Dépaquetage](#dépaquetage)
        3. [Installation & Mise en service](#installation--mise-en-service)
    3. [Ajouter l'hôte à Prometheus](#ajouter-lhôte-à-prometheus)

## Étapes de Configuration

### 1. Télécharger les Images Docker

```bash
docker pull prom/prometheus
docker pull grafana/grafana
```

### 2. Lancer le Conteneur Prometheus

```bash
docker run --name prometheus -d -p 127.0.0.1:9090:9090 prom/prometheus
```

Cela lance un conteneur Prometheus accessible localement à l'adresse http://localhost:9090.

### 3. Lancer le Conteneur Grafana

```bash
docker run -d --name=grafana -p 3000:3000 grafana/grafana
```

Cela lance un conteneur Grafana accessible localement à l'adresse http://localhost:3000.

## 4. Installation de win-exporter

Pour la supervision, nous sommes passés par Grafana et plus particulièrement par Prometheus pour récupérer les données des machines.

Afin de récupérer les données des machines Windows, nous avons d'abord dû installer Chocolatey. Exécutez la commande suivante dans PowerShell :

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
```

Ensuite, installez win-exporter :

```powershell
choco install prometheus-wmi-exporter.install
```

![image](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/161329881/ff1d2263-a267-4d67-a48e-4e0bbe639204)

### Configuration de Prometheus

Configurez Prometheus dans le fichier `/etc/prometheus/prometheus.yml` avec les informations suivantes :

```yaml
- job_name: 'win-exporter'
  static_configs:
    - targets: ['192.168.9.5:9182', '172.16.3.3:9182']
```

Une fois cette configuration effectuée, redémarrez le service Prometheus. Vous verrez ceci sur l'interface web :

![image](https://github.com/WildCodeSchool/TSSR-2402-P3-G4-BuildYourInfra-Pharmgreen/assets/161329881/382294f7-eba6-4f56-a4b4-dd7bdeca5aa8)

## 5. Installer Node Exporter et ajouter à Prometheus

### A quoi sert Node Exporter ?

Node Exporter récupère les métriques du système et les rend disponibles via une simple requête curl.

### Installation

#### Téléchargement

Téléchargez la dernière version de Node Exporter :

```bash
wget https://github.com/prometheus/node_exporter/releases/download/v1.0.1/node_exporter-1.0.1.linux-amd64.tar.gz
```

#### Dépaquetage

Extrayez l'archive :

```bash
tar -xvf node_exporter-1.0.1.linux-amd64.tar.gz
mv node_exporter-1.0.1.linux-amd64/node_exporter /usr/local/bin/
```

### Installation & Mise en service

Créez un utilisateur `node_exporter` pour gérer le service :

```bash
useradd -rs /bin/false node_exporter
```

Créez le service systemd pour Node Exporter :

```bash
nano /etc/systemd/system/node_exporter.service
```

Ajoutez les informations suivantes dans le fichier :

```ini
[Unit]
Description=Node Exporter
After=network.target

[Service]
User=node_exporter
Group=node_exporter
Type=simple
ExecStart=/usr/local/bin/node_exporter

[Install]
WantedBy=multi-user.target
```

Rechargez le daemon et démarrez Node Exporter :

```bash
systemctl daemon-reload
systemctl start node_exporter
systemctl status node_exporter
```

Activez Node Exporter au démarrage :

```bash
systemctl enable node_exporter
```

Vérifiez son bon fonctionnement :

```bash
curl http://localhost:9100/metrics
```

### Ajouter l'hôte à Prometheus

Pour modifier le fichier de configuration de Prometheus, utilisez :

```bash
vi /etc/prometheus/prometheus.yml
```

Ajoutez un target avec l'adresse IP voulue :

```yaml
- job_name: 'node_exporter'
  scrape_interval: 5s
  static_configs:
    - targets: ['localhost:9100']
    - targets: ['192.168.0.2:9100']
```

Redémarrez le service Prometheus pour appliquer les modifications :

```bash
systemctl restart prometheus
```

Vérifiez que votre hôte apparaît sur l'interface Prometheus ou Grafana.

### Pour entrer dans un conteneur Docker et effectuer des opérations, utilisez la commande suivante :

```bash
docker exec -it <nom_du_conteneur> /bin/bash
```

Remplacez `<nom_du_conteneur>` par le nom ou l'ID de votre conteneur.
