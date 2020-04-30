# S3 Bucket automated Backup

We all have come to the point when we need to decide what to do about backing up a website. There are many solutions out there. 
I had the necessity to backup many websites and have also a quick way to manage it across many instances of Wordpress. I am going to share with you my solution and I would really appreciate your feedback about it.

## Getting Started

SSH into your Linux instance (ubuntu in my case) and clone the repo in the backup folder. 
Create the folder /home/ubuntu/backup/repo/ folder

### Prerequisites

There are not specific requirement. Just maske sure you are running the last updated version of Ubuntu.


### Installing

Clone the repo then add the cronjob by 

```
crontab -e
```

then add the cronjob, in my case I am exectuting a backup at midnight:

```
0 0 * * * /home/ubuntu/backup/backup.sh "/home/ubuntu/backup/repo" "your-s3-backup-folder" "your-wordpress-document-root-absolute-path" "your-db-name" > /home/ubuntu/backup/backup.log
```

This will enable an automated backup every midnight.

## The Bash Script is explained in the following medium article:

https://medium.com/@domenicorutigliano/how-to-automate-your-wordpress-site-backup-to-amazon-s3-using-a-bash-script-b355d147262d?sk=f47710e4f12b5ba7844c33e2d2e4c21f


## Versioning

We use [Gitlab](https://gitlab.com/) for versioning. For the versions available, see the [tags on this repository](https://gitlab.com/rutigliano/s3-bucket-bashscrip-backup). 

## Authors

* **Domenico Rutigliano** - *Senior Software Engineer* - [WPOpera](https://gitlab.com/rutigliano/)



## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

