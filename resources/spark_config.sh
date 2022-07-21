#!/bin/bash

## ****** move spark *************
STATUS="moving spark folder ..."
echo $STATUS
sudo mv /spark-3.3.0-bin-hadoop2 /opt/spark
STATUS="successfully moved spark"
echo $STATUS

## ****** edit profile *************
STATUS="edit profile..."
echo $STATUS
echo "export SPARK_HOME=/opt/spark" >> ~/.profile
source ~/.profile
echo "export PYSPARK_PYTHON=/usr/bin/python3">> ~/.profile
echo "export PATH=$PATH:$SPARK_HOME/bin:$SPARK_HOME/sbin">> ~/.profile
source ~/.profile
STATUS="successfully edited .profile"
echo $STATUS

## ****** start master and slave *************
STATUS="start master and slave..."
echo $STATUS
/opt/spark/sbin/start-master.sh 
/opt/spark/sbin/start-worker.sh spark://`hostname`:7077
#source ~/.profile
STATUS="successfully started workers and master"
echo $STATUS
