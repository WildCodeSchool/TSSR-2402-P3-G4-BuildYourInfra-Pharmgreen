$FilePath = [System.IO.Path]::GetDirectoryName($MyInvocation.MyCommand.Definition)

$ConfigFile = "$FilePath\configAD-DS.csv"

# Importer le fichier de configuration "configAD-DS.csv"
$Config = Import-Csv -Path $ConfigFile -Delimiter "," -Header "ServerName","IPAddress","Gateway","Domain"

# Varible qui extrait les paramètres du fichier de configuration
$serverCore = $Config.ServerName
$adresseIp = $Config.IPAddress
$gateway = $Config.Gateway
$domain = $Config.Domain

###############  Menu  #################

# Renommer l'ordinateur
Rename-Computer -NewName $serverCore -Force

# Configurer l'adresse IP
$interfaceIndex = (Get-NetAdapter).ifIndex
New-NetIPAddress -IPAddress $adresseIp -PrefixLength 24 -InterfaceIndex $interfaceIndex -DefaultGateway $gateway

# Configurer l'adresse DNS
Set-DnsClientServerAddress -InterfaceIndex $interfaceIndex -ServerAddresses $domain

# Installer les fonctionnalités de l'AD-DS
Install-WindowsFeature -Name RSAT-AD-Tools -IncludeManagementTools -IncludeAllSubFeature
Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools -IncludeAllSubFeature
Install-WindowsFeature -Name DNS -IncludeManagementTools -IncludeAllSubFeature

# Promouvoir le contrôleur de domaine
Install-ADDSDomainController -DomainName $domain -Credential (Get-Credential)

# Vérifier le contrôleur de domaine
Get-ADDomainController -Identity $serverCore

# Redémarrer l'ordinateur
Restart-Computer
