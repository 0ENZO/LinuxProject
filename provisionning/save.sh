#!/bin/bash

d=$(date +%m-%d-%Y-%H-%M)
ip="192.168.1.30"
path="home/save/backup2"
user="save"

#Met à jour la liste des utilisateurs et enregistre en db
./store_users.sh
mysql --local-infile=1 < users.sql
mysqldump users_db > "users_db.$d.sql";

#Archive tous les dossiers utilisateurs et les envoie sur la machine de save
for dir in $(ls /home)
do
    tar zcvf "$dir.$d.tgz" "/home/$dir";
    scp "$dir.$d.tgz" "$user"@"$ip":/"$path"
done

#Transfère le dump de la db
scp "users_db.$d.sql" "$user"@"$ip":/"$path"

#Déplace les archives et le dump de la db
mv users_db.* users_db/
mv *.tgz users_tgz/

#Transfère la liste des utilisateurs et les scripts
#scp store_users.sh "$user"@"$ip":/"$path/provisionning/"
#scp mv_ssh.sh "$user"@"$ip":/"$path/provisionning/"
#scp save.sh "$user"@"$ip":/"$path/provisionning/"
#scp users.sql "$user"@"$ip":/"$path/provisionning/"

for file in $(ls)
do
	if [ -f $file ]
	then
		scp $file "$user"@"$ip":/"$path/"
	fi
done

#Déplace les fichiers transférés sur la machine de save
ssh "$user"@"$ip" /bin/bash << EOF
	cd backup2/
	mv users_db.* users_db/
	mv *.tgz users_tgz/
	mv *.* /provisionning
EOF
