#!/bin/bash

### **********************************************************

##  Installiation of Spark for Ubutnu 20.04

### **********************************************************

STATUS='starting installation of spark dependencies ...' 
echo $STATUS

## ****** update apt-get *************
STATUS="updating apt-get ..."
echo $STATUS
sudo apt-get update
STATUS="successfully updated apt-get"
echo $STATUS

## ****** pip3 install *************
STATUS="installing python3-pip ..."
echo $STATUS
sudo apt install python3-pip -y
STATUS='successfully installed python3-pip'
echo $STATUS

## ****** python jupyter install *************
STATUS="installing jupyter ..."
echo $STATUS
pip3 install jupyter
STATUS="successfully installed jupyter"
echo $STATUS

## ****** installing jupyter-core *************
STATUS="installing jupyter-core ..."
echo $STATUS
sudo apt install jupyter-core - y
STATUS="successfully installed jupyter-core"
echo $STATUS

## ****** installing default-jre *************
STATUS="installing default-jre ..."
echo $STATUS
sudo apt-get install default-jre -y
STATUS="successfully installed default-jre"
echo $STATUS

## ****** installing scala *************
STATUS="installing scala ..."
echo $STATUS
sudo apt-get install scala -y
STATUS="successfully installed scala"
echo $STATUS

## ****** installing py4j *************
STATUS="installing py4j ..."
echo $STATUS
pip3 install py4j
STATUS="successfully installed py4j"
echo $STATUS

## ****** downloading spark tgz *************
STATUS="downloading spark-3.3.0-bin-hadoop2.tgz ..."
echo $STATUS
wget http://archive.apache.org/dist/spark/spark-3.3.0/spark-3.3.0-bin-hadoop2.tgz
STATUS="successfully completed downloading spark-3.3.0-bin-hadoop2.tgz"
echo $STATUS

## ****** extract tarball files *************
STATUS="unzip, extract, spark hadoop tarball ..."
echo $STATUS
sudo tar -zxvf spark-3.3.0-bin-hadoop2.tgz
STATUS="successfully extracted tarball files"
echo $STATUS

## ****** installing findspark *************
STATUS="installing findspark ..."
echo $STATUS
pip3 install findspark
STATUS="successfully installed findspark"
echo $STATUS
echo 'Completed installation of spark!'

### **********************************************************

##  Installiation of MongoDB for Ubutnu 20.04

### **********************************************************


### ****** install mongodb *************
STATUS="starting installation of mongodb ..."
echo $STATUS

### ****** install mongodb *************
STATUS="installing gnupg ..."
echo $STATUS
sudo apt-get install gnupg -y
STATUS="sucessfully installed gnupg"
echo $STATUS

### ****** Import Mongodb Key *************
STATUS="Importing Publice Key for PMS ..."
echo $STATUS
wget -qO - https://www.mongodb.org/static/pgp/server-5.0.asc | sudo apt-key add -
STATUS="sucessfully imported Public Key."
echo $STATUS

### ****** Create list file for MongoDB *************
STATUS="Creating List file Ubuntu 20.04 (Focal) ..."
echo $STATUS
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/5.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-5.0.list
STATUS="Sucessfully Create List file"
echo $STATUS

### ****** Update apt-get *************
STATUS="Update apt-get ..."
echo $STATUS
sudo apt-get update
STATUS="Sucessfully Installed apt-get"
echo $STATUS

### ****** Install MongoDB w/ PMS *************
STATUS="Installing MongoDB Packages ..."
echo $STATUS
sudo apt-get install -y mongodb-org
STATUS="Successfully installed MongoDB Packages"
echo $STATUS
### ****** Reload & Start MongoDB Daemon *************
STATUS="Reloading MongoDB Daemon ..."
echo $STATUS
sudo systemctl daemon-reload
STATUS="Starting MongoDB Daemon ..."
echo $STATUS
sudo systemctl start mongod
STATUS="Successfully Started MongoDB"
echo $STATUS