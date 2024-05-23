$FilePath = [System.IO.Path]::GetDirectoryName($MyInvocation.MyCommand.Definition)

$ConfigFile = "$FilePath\configAD-DS.csv"

# Importer le fichier de configuration "configAD-DS.csv"
$Config = Import-Csv -Path $ConfigFile -Delimiter "," -Header "ServerName","IPAddress","Gateway","DNS","Domain","User","Password"

# Varible qui extrait les paramètres du fichier de configuration
$serverCore = $Config.ServerName # Indiqué dans le csv nom du serveur CORE
$adresseIp = $Config.IPAddress # Indiqué dans le csv l'adresse IP
$gateway = $Config.Gateway # Indiqué dans le csv l'adresse IP de la paserelle
$DNS = $Config.dns # Indiqué dans le csv l'adresse IP du DNS
$domain = $Config.Domain # Indiqué dans le csv le nom du domaine exemple.orgin
$User = $Config.user #indique le comtpe de connection
$Password = $Config.password # indique le mot de passe de connection

###############  Menu  #################


# Configurer l'adresse IP
$interfaceIndex = (Get-NetAdapter).ifIndex
New-NetIPAddress -IPAddress $adresseIp -PrefixLength 24 -InterfaceIndex $interfaceIndex -DefaultGateway $gateway

# Configurer l'adresse DNS
Set-DnsClientServerAddress -InterfaceIndex $interfaceIndex -ServerAddresses $DNS

# Installer les fonctionnalités de l'AD-DS
Install-WindowsFeature -Name RSAT-AD-Tools -IncludeManagementTools -IncludeAllSubFeature
Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools -IncludeAllSubFeature
Install-WindowsFeature -Name DNS -IncludeManagementTools -IncludeAllSubFeature

# Ajouter le serveur core au domain
$Pass= ConvertTo-SecureString $password -AsPlainText -Force
$credential = New-Object System.Management.Automation.PScredential ("$User@$Domain", $Pass) 
Add-Computer -DomainName $domain -credential $credential

# Renommer l'ordinateur
Rename-Computer -NewName $serverCore -Force

# Redémarrer l'ordinateur
Restart-Computer
