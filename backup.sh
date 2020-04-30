#!/bin/bash

#Checking if the right amount of parameters is passed and pirnt out a quick "how to" in case is not. 

if [ "$#" -ne 4 ]; then
printf "\n#################################################### 
        \nAWS S3 Backup Script - Please define in order: \n\n 
        1) Website Document Root path \n 
        2) Backup File Name \n 
        3) S3 Backet Folder name \n 4) DB Name \n\n"
exit 2
fi

REPOFOLDER=$1    #the Wordpress document Root. 
FILE=$2     #the filename for the backup Archive 
AWS_PATH=$3 #the path for the S3 Bucket
DBNAME=$4  #the DB name

source params.env #Sourcing the API Keys and DB user/password specific of each env.

Filename="$(date +'%Y-%m-%d-%H-%M')-backup-$file"


mysqldump --host=localhost --user=root --password=123qwe --add-drop-table --result-file=/home/ubuntu/backup/repo/$Filename.sql $4

/usr/bin/zip /home/ubuntu/backup/repo/$Filename.sql.zip /home/ubuntu/backup/repo/$Filename.sql
rm /home/ubuntu/backup/repo/$Filename.sql

/usr/bin/zip -r  /home/ubuntu/backup/repo/$Filename.www.zip /var/www/$3/  -y  -x "*.sql"


function putS3
{
  path=$1
  file=$2
  aws_path=$3
  bucket='wpopera-backup'
  date=$(date +"%a, %d %b %Y %T %z")
  acl="x-amz-acl:public-read"
  content_type='application/zip'
  string="PUT\n\n$content_type\n$date\n$acl\n/$bucket$aws_path$file"
  signature=$(echo -en "${string}" | openssl sha1 -hmac "${S3SECRET}" -binary | base64)
  curl -X PUT -T "$path/$file" \
    -H "Host: $bucket.s3.amazonaws.com" \
    -H "Date: $date" \
    -H "Content-Type: $content_type" \
    -H "$acl" \
    -H "Authorization: AWS ${S3KEY}:$signature" \
    "https://$bucket.s3.amazonaws.com$aws_path$file"
}

for file in "$REPOFOLDER"/*; do
  putS3 "$1" "${file##*/}" "/$2/"
  filesize=($(du -sh $1"/"${file##*/}))
 /home/ubuntu/backup/push.sh "$2 Backup Notification" "${file##*/} ${filesize[0]} completed"
done

rm /home/ubuntu/backup/repo/*.zip
