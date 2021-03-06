
# Description

  In this project we write a interpreter for the Alarmdepesche of german fire departments like Thuringia.

# Installation

     $ yum install python-pip
     $ pip install --upgrade pip
     $ pip install imaplib
     $ pip install beautifulsoup4
     $ pip install HTMLParser
     $ pip install bs4
     $ pip install lxml

## Python full rest service
     $ pip install flask
     $ pip install -U flask-cors

## MySQL Datenbank
     $ yum install python python-devel mysql-devel redhat-rpm-config gcc
     $ pip install MySQL-python

## Firewall

     $ iptables -I INPUT 1 -p tcp -m tcp --dport 80 -m conntrack --ctstate NEW -j ACCEPT
     $ iptables -I INPUT 1 -p tcp -m tcp --dport 5000 -m conntrack --ctstate NEW -j ACCEPT

## Web server

     $ yum install -y httpd
     $ systemctl enable httpd

  In the Document space of the web server conig file add the header part for cros site requests:

     Header set Access-Control-Allow-Origin "*"
     Header set Access-Control-Allow-Headers: Content-Type

# Create a config file

  For the imap login it is usefule to create a file with the name 'alarmdepescheconfig.py'.
  The content of the file can look like:

     #!/usr/bin/env python
     imap = {'host': 'imap.meinServer.de',
             'port': '993',
             'user': 'myMail@myProvider.domain',
             'passwd': 'XXXXX',
             'mailBox': 'INBOX',
             'checkIntervall' : '30'
     }

     mysql = {'host'   : 'localhost',
              'user'   : 'root',
              'passwd' : '',
              'dbName' : 'FeuerwehrNotifications'
     }

# Create used database schema

  In my point i use a mysql db.

     mysql> create database FeuerwehrNotifications CHARACTER SET utf8 COLLATE utf8_general_ci;
     mysql> create table Alarmdepesche (id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT, dbIN TIMESTAMP DEFAULT CURRENT_TIMESTAMP, messageID BIGINT UNSIGNED
            , Einsatzstichwort VARCHAR(512), AlarmiertesEinsatzmittel VARCHAR(512), Sondersignal VARCHAR(512), Einsatzbeginn VARCHAR(512), Einsatznummer VARCHAR(512), Name VARCHAR(512), Zusatz VARCHAR(512), Sachverhalt VARCHAR(512), Patientenname VARCHAR(512)
	    , Target_Objekt VARCHAR(512), Target_Objekttyp VARCHAR(512), Target_StrasseHausnummer VARCHAR(512), Target_Segment VARCHAR(512), Target_PLZOrt VARCHAR(512), Target_Region VARCHAR(512), Target_Info VARCHAR(512)
	    , TransTarget_Transportziel VARCHAR(512), TransTarget_Objekt VARCHAR(512), TransTarget_Objekttyp VARCHAR(512), TransTarget_StrasseHausnummer VARCHAR(512), TransTarget_PLZOrt VARCHAR(512)
	    , PRIMARY KEY (id));


     $ vim /etc/my.conf
     [mysqld]
     character-set-server=utf8
     collation-server=utf8_general_ci
     skip-character-set-client-handshake

## Autostart database server

     $ systemctl enable mysqld


# Run

     $ python -m Alarmdepesche

     $ rsync -avz ./html/* /var/www/html/Alarmdepesche/

# Write own modules

For write own modules or extend code read the document ApiDescription.md

# Docker

     $ docker build -t feuerwehr-alarmdepesche .
     $ docker run -l feuerwehr-alarmdepesche-app -it --pid=host -p 5080:80 -p 5000:5000 feuerwehr-alarmdepesche

## Test

     $ docker run -l feuerwehr-alarmdepesche-dev -it --pid=host -p 5080:80 -v "$PWD/html":/var/www/html -p 5000:5000 -v "$PWD":/usr/FeuerwehrAlarmdepesche/ feuerwehr-alarmdepesche bash
     $ /usr/bin/mysqld_safe & sleep 5; mysql -u root < dbinit.sql
     $ mysql -u root FeuerwehrNotifications < vorlagen/oneMessage.sql
     $ python3 -m Alarmdepesche Alarmdepesche/__main__.py
     $ python3 -m Alarmdepesche.modules.email
or
     $ docker run -l feuerwehr-alarmdepesche-dev -it --rm --pid=host -p 5000:5000 feuerwehr-alarmdepesche bash
     $ docker run -l feuerwehr-alarmdepesche-dev2 -it --rm --pid=host -p 5000:5000 -v LOCAL_APP_FOLDER:/usr/FeuerwehrAlarmdepesche feuerwehr-alarmdepesche bash


## Single instance

     $ docker run -it --rm --name my-running-script -p 5000:5000 -v "$PWD":/usr/src/myapp -w /usr/src/myapp python:2 python your-daemon-or-script.py
     $ docker run -it --rm --name my-running-script -v "$PWD":/usr/src/myapp -w /usr/src/myapp python:3 python your-daemon-or-script.py

# The new core module concept

     $ PYTHONPATH=./ python3 Alarmdepesche/__main__.py
     $ python3 -m Alarmdepesche Alarmdepesche/__main__.py


# Rest api call

     $ curl "http://127.0.0.1:5000/api/v1.0/Alarmdepesche"


# OpenStreetMaps

  - wget http://dev.openlayers.org/examples/osm-marker-popup.js
  - wget https://github.com/openlayers/ol2/releases/download/release-2.13.1/OpenLayers-2.13.1.tar.gz




