#!/bin/bash
## ****** creating certs directory *************
STATUS="creating certs directory ..."
echo $STATUS
mkdir /home/ubuntu/certs
cd /home/ubuntu/certs
STATUS="successfully created certs directory"
echo $STATUS

## ****** created pem key *************
STATUS="creating pem key ..."
echo $STATUS
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /home/ubuntu/certs/mycert.pem -out /home/ubuntu/certs/mycert.pem -subj '/CN=LinuxSandbox/O=Demo/C=US/ST=NY/L=NYC'
STATUS="successfully created pem key"
echo $STATUS

## ****** chown pem key *************
STATUS="chown pem key ..."
echo $STATUS
sudo chown ubuntu:ubuntu /home/ubuntu/certs/mycert.pem
STATUS="successfully completed chown pem key"
echo $STATUS

## ****** update PATH*************
STATUS="updating PATH ..."
echo $STATUS
export PATH=$PATH:~/.local/bin
STATUS="sucessfully updated PATH ..."
echo $STATUS

# ****** generate config file for spark *************
##force MarkUpSafe verison --else error occurs when creating
#config file... 
STATUS="MarkUpSafe/Jinja2 Fix"
echo $Status
pip3 install --force-reinstall Jinja2==3.0.3
pip3 install --force-reinstall MarkupSafe==2.0.1
STATUS="sucessfully reinstalled MarkupSafe/jinja2"
echo $STATUS


STATUS="generate jupyter config file ..."
echo $STATUS
sudo runuser -u ubuntu -- jupyter notebook --generate-config
STATUS="sucessfully generated jupyter config file"
echo $STATUS

echo 'Completed config file!'

~/resources/configure_edit.py