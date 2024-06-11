## instalation de CLoneZilla

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

![alt text](image-5.png)

- appuyer sur entrée

![alt text](image-7.png)

- appuyer sur entrée

![alt text](image-8.png)

- appuyer sur entrée

- executer la commande `drblpush -i`

![alt text](image-9.png)

- rentrer le nom de domaine : **pharmgreen.org**
- appuyer sur entré

![alt text](image-10.png)

- appuyer sur entré

![alt text](image-11.png)

- appuyer sur entré

![alt text](image-12.png)

- appuyer sur entré

![alt text](image-13.png)

- appuyer sur entré

![alt text](image-14.png)

- reponse : N

![alt text](image-15.png)

- appuyer sur entré

![alt text](image-16.png)

- mettre 2 qui correspond au dernier octet de l'adresse ip 

![alt text](image-17.png)

- mettre 20(le serveur va pouvoir acceder de l'adresse x.x.x.2 a x.x.x.21)

![alt text](image-18.png)

- apuyer sur entré
- le resultat devrais etre :

![alt text](image-19.png)

- appuyer sur entré

![alt text](image-20.png)

- appuyer sur entré

![alt text](image-21.png)

- appuyer sur entré

![alt text](image-22.png)

- appuyer sur entré (Les clones seront stocker dans /home/partimag)

![alt text](image-23.png)

- appuyer sur entré

![alt text](image-24.png)

- appuyer sur entré

![alt text](image-25.png)

- appuyer sur entré

![alt text](image-26.png)

- appuyer sur entré

![alt text](image-27.png)

- appuyer sur entré

![alt text](image-28.png)

- appuyer sur entré

![alt text](image-29.png)

- appuyer sur entré

![alt text](image-30.png)

- appuyer sur entré

![alt text](image-31.png)

- appuyer sur entré

![alt text](image-32.png)

- appuyer sur entré

![alt text](image-33.png)

- appuyer sur entré

![alt text](image-34.png)

- appuyer sur entré

![alt text](image-35.png)

- reponse : N

![alt text](image-36.png)

- appuyer sur entré

![alt text](image-37.png)

- appuyer sur entré

- executer la commande `dcs`

![alt text](image-38.png)

- choisir la premiere option

![alt text](image-39.png)

- choisir **clonezilla-start**

![alt text](image-40.png)

- choisir le mode **Beginner**

![alt text](image-41.png)

- choisir **select-in-client**

![alt text](image-42.png)

- choisir la premiere option

![alt text](image-43.png)

- choisir **poweroff**
