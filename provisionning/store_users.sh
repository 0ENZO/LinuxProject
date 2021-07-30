#!/bin/bash
tmpFile="/tmp/line.txt"
outputFile="users.xml"

if [ -s $outputFile ]
then
        rm $outputFile
        touch $outputFile
	echo "Fichier existant, suppression du precedent" 
fi

echo '<?xml version="1.0"?>' >> $outputFile
echo "<users>" >> $outputFile
for i in $(cut -d: -f1,3,4,6,7 /etc/passwd)
do
	echo $i > $tmpFile
        name=$(cut -d: -f1 $tmpFile)
        uid=$(cut -d: -f2 $tmpFile)
        gid=$(cut -d: -f3 $tmpFile)
        home=$(cut -d: -f4 $tmpFile)
        shell=$(cut -d: -f5 $tmpFile)
        if [ $shell = "/bin/bash" ]
        then
                #size=$(du $home -sh)
		echo "$name en cours de traitement"
                size=$(stat -c%s $home)
                fingerprint=$(find $home -type f -exec md5sum {} \; > /tmp/md5 && md5sum /tmp/md5 | awk '{print $1}')
                echo -e "\t<user>" >> $outputFile
                echo -e "\t\t<name>$name</name>" >> $outputFile
                echo -e "\t\t<uid>$uid</uid>" >> $outputFile
                echo -e "\t\t<gid>$gid</gid>" >> $outputFile
                echo -e "\t\t<home>$home</home>" >> $outputFile
                echo -e "\t\t<taille>$size</taille>" >> $outputFile
                echo -e "\t\t<fingerprint>$fingerprint</fingerprint>" >> $outputFile
                echo -e "\t</user>" >> $outputFile
        fi
done
echo "</users>" >> $outputFile
echo "Sauvegarde des users terminée"

