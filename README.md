# AWS EC2 Unbutu 20.04 Sandbox
#### _Deploy an Ubuntu Server with Spark, MongoDB and Juptyer w/ AWS CDK_

### About
This Repository contains IaC for spinning up a generic ubuntu web server for testing purposes. This server allows all ingress/outbound traffic on ports by default. But can be configured as needed.
Note that all logs & security groups are designed to be destoryed once EC2 instance is torn down.

### Getting Started 
- This assumes AWS CDK is already installed on your machine. If not, see installation instructions [here](https://docs.aws.amazon.com/cdk/v2/guide/getting_started.html)
- In your AWS Console, go to `EC2 Dashboard`, Click on `Key Pairs`, Create and Download a new `Key Pair`
- On your local machine perform `chmod 400` on the pem file. Example: `chmod 400 ~/Downloads/Ec2ubuntu.pem`
- Clone this repo and Create  a Virtual Environment. Ensure to use `pip install -r requirements.txt`
- In the `CDK.JSON` file, update the *vpc_configs* sub-section in the  *context* section.
  - **default_vpc_id**: VPC you want to place your EC2 Instance in. You can find your default VPC for your account in the AWS EC2 Dashboard in the Account Attributes section. A VPC ID will look something like: ` vpc-9aa9999`
  - **region**: Your AWS region Availibility Zone (ie. "us-east-1")
  - **key_name**: The name of the key pair you created and downloaded
  - **account**: Your AWS Account Number (No Dashes "-")
- Execute CDK Commands to Bootstrap, Synth and Deploy as needed. You can get a refresher [here](https://docs.aws.amazon.com/cdk/v2/guide/hello_world.html).
- When the the Stack is deployed SSH into the Server and then complete the configuration for Spark and Jupyter via provided bash scripts provided in the resources folder. See SSH Section below.

### Deploying the Stack
Once the stack is deployed, installation dependencies will commence for Spark, Jupyter and MongoDB. Such that it is possible that when you SSH into the server for the first times items are still being installed. It takes about 2-3 minutes for installation steps to complete. You can check the progress of the installations in the log file to make sure the items are complete (`tail -f /var/log/cloud-init-output.log `)
A completed message will be at the end log file. It should look like so....
```
Successfully installed MongoDB Packages
Reloading MongoDB Daemon ...
Starting MongoDB Daemon ...
Successfully Started MongoDB
Cloud-init v. 22.2-0ubuntu1~20.04.1 running 'modules:final' at Wed, 20 Jul 2022 19:19:35 +0000. Up 25.26 seconds.
Cloud-init v. 22.2-0ubuntu1~20.04.1 finished at Wed, 20 Jul 2022 19:22:53 +0000. Datasource DataSourceEc2Local.  Up 222.82 seconds
```
Also note, that when the AWS CDK stack is deployed an output will show the Public IP of the server. It will look something like this:
>MongoSparkStack.WebServerMongoSparkIDpublicIP= 56.996.45.1

### SSH: 
Below is the general syntax to perform various SSH Commands

_**connect syntax**_: SSH into Ubuntu EC2 Instance <br> 
*syntax*:`ssh -i ~/Downloads/your-key-file.pem ubuntu@public_ip`<br>
*example*:`ssh -i ~/Downloads/my-ec2-spark-cluster.pem ubuntu@54.242.117.16`

_**copying resouces files to EC2 syntax**_:  Copying files from your local machine to EC2 Instance <br>
*syntax*:`scp -i ~/Downloads/your-key-file.pem -r ~/path/to/clone/folder/aws-ec2-spark-mongo/resources ubuntu@your.public.ip:~/ ` <br>
*example*:`scp -i ~/Downloads/my-ec2-spark-cluster.pem -r ~/pythonprojects/aws-ec2-spark-mongo/resources ubuntu@54.242.117.16:~/ `


### Starting a Jupyternotebook
- First copy the resources project folder to the EC2 server
- From ubuntu home directory execute: `bash resources/jupyter_config.sh` (Only need to do this once)
- Verify the configurations completed by peforming: <br>
`head .jupyter/jupyter_notebook_config.py`. Results should look as follows:
  >c = get_config() <br>
  c.NotebookApp.certfile= u'/home/ubuntu/certs/mycert.pem'<br>
  c.NotebookApp.ip = '*'<br>
  c.NotebookApp.open_browser = False<br>
  c.NotebookApp.port = 8888
- With ubuntu user, execute `jupyter notebook`
- Copy url ex:`https://127.0.0.1:8888/?token=76bc85688fd7ab6a1021b890480f371cf7ddfb6f40ecd9d0`
- Replace 127.0.0.1 with ec2 Public IP. 
- Paste URL in browser,read warning details, select continue (visit site). **Note**: Chrome Browser may not allow visitng site because of security configurations. Recommend using Safari if on Mac. 
- **Note**: its is possible to use Spark on JupyterNotebook. _findspark_ package is available.
- psypark can be found in Jupyter notebook as follows:
  >#first find spark...<br>
  import findspark<br>
  findspark.init('/opt/spark')<br>
  #then we can can import pyspark stuff..<br>
  from pyspark import SparkConf<br>
  from pyspark.context import SparkContext<br>
  from pyspark.sql import SQLContext, SparkSession<br> 

## Starting Mongo Shell
- `sudo su`; then execute `mongosh`

## Starting PySpark
- First copy the resources project folder to the EC2 server
- From ubuntu Home Directory execute:`bash resources/spark_config.sh` (Only need to do this once)
- Referesh profile `source ~/.profile` (Only need to do this once)
- Execute `pyspark` command with Ubuntu user
- Note by default the server adds 1 master and 1 work node.
- You can visit your spark web ui by visting `http://your.pub.lic.ip:8080/`
