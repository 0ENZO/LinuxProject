#!/bin/bash
#Déplace les fichiers transférés sur la machine de save
ssh save@192.168.1.30 /bin/bash << EOF
	cd backup2/
	mv users_db.* users_db/
	mv *.tgz users_tgz/
EOF
