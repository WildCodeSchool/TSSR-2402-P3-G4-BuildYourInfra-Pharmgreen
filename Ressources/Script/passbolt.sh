#!/bin/bash

# Mettre à jour les paquets
apt-get update

# Installer Java pour Elasticsearch et Logstash
apt-get install -y openjdk-11-jdk

# Ajouter le dépôt Elasticsearch et installer Elasticsearch
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | apt-key add -
echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | tee -a /etc/apt/sources.list.d/elastic-7.x.list
apt-get update
apt-get install -y elasticsearch

# Configurer et démarrer Elasticsearch
systemctl enable elasticsearch
systemctl start elasticsearch

# Ajouter le dépôt Wazuh et installer Wazuh Manager
curl -s https://packages.wazuh.com/key/GPG-KEY-WAZUH | apt-key add -
echo "deb https://packages.wazuh.com/4.x/apt stable main" | tee /etc/apt/sources.list.d/wazuh.list
apt-get update
apt-get install -y wazuh-manager

# Configurer et démarrer Wazuh Manager
systemctl enable wazuh-manager
systemctl start wazuh-manager

# Ajouter le dépôt Filebeat et installer Filebeat
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | apt-key add -
echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | tee -a /etc/apt/sources.list.d/beats.list
apt-get update
apt-get install -y filebeat

# Configurer Filebeat pour envoyer les journaux à Elasticsearch
cat <<EOL > /etc/filebeat/filebeat.yml
output.elasticsearch:
  hosts: ["http://localhost:9200"]
EOL

# Configurer Filebeat pour utiliser les modules Wazuh
filebeat modules enable wazuh

# Démarrer Filebeat
systemctl enable filebeat
systemctl start filebeat

# Installer Kibana
apt-get install -y kibana

# Configurer Kibana pour qu'il pointe vers Elasticsearch
cat <<EOL > /etc/kibana/kibana.yml
server.port: 5601
server.host: "0.0.0.0"
elasticsearch.hosts: ["http://localhost:9200"]
EOL

# Démarrer Kibana
systemctl enable kibana
systemctl start kibana

# Afficher l'état des services
systemctl status elasticsearch
systemctl status wazuh-manager
systemctl status filebeat
systemctl status kibana
