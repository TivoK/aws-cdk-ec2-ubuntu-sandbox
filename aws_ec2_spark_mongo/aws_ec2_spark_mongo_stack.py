"""AWS EC2 Spark Mongo Stack

This module defines the AWS CloudFormation Stack for creating an EC2
instance with Ubuntu (20.04 LTS, Focal), with the t2.micro (free-tier)
instance type. In addition, this stack will pre-install dependencies
required for spark 3.3.0 and mongodb server (latest version).

This requires AWS_CDK to deploy the IaC defined below.

This file can be imported and contains the following the function(s) & Class('s):
    - create_environment: Creates AWS CDK Environment Class.
    - AwsEc2SparkMongoStack: Creates CloudFormation Stack EC2 stack w/ Spark and MongoDB.
"""
import json
from aws_cdk import (

    Stack,
    aws_ec2 as _ec2,
    CfnOutput,
    Tags,
    RemovalPolicy,
    Environment

)
from constructs import Construct

def create_environment()-> Environment:
    """Creates AWS CDK Environment Class based on CDK.JSON parameter values.

    :params: None

    :returns: Environment
    """
    with open('cdk.json',mode='r',encoding='utf-8') as file:
        data = json.load(file)
        vpc = data['context']['vpc_configs']

    return Environment(account=vpc['account'], region=vpc['region'])

class AwsEc2SparkMongoStack(Stack):
    """IaC for Creating an EC2 Ubuntu (20.04 LTS, Focal) w/ Spark and MongoDB Server.

    The intended purpose of this instance is to create a Linux Sandbox Server for testing.
    The instance created will have the following configs:
        - userdata: spark-3.3.0, mongo 5.0 (latest version)
        - security group: SecGroupSparkMongoEC2 (Removal Policy:DESTROY)
        - ingress rules: Allow All inbound Traffic
        - outbound rules: Allow All outbound Traffic
        - cdk.json: Ensure that "vpc_configs" values are updated for personal account settings


    Attributes
    ----------
    None

    Methods
    -------
    None
    """

    def __init__(self, scope: Construct, construct_id: str, **kwargs) -> None:
        super().__init__(scope, construct_id, **kwargs)

        # The code that defines your stack goes here
        def_vpc=_ec2.Vpc.from_lookup(
            self
            ,"default_vpc"
            #here we are using the personal account default
            #you will have to update this value in the cdk.json
            #for personal use.
            ,vpc_id=self.node.try_get_context("vpc_configs")["default_vpc_id"]
        )

        with open('bootstrap/install_spark_mongo.sh', mode='r', encoding='utf-8') as file:
            install_dependencies = file.read()

        sec_group =_ec2.SecurityGroup(
            self
            ,'SecGroupSparkMongoEC2ID'
            ,security_group_name='SecGroupSparkMongoEC2'
            ,vpc=def_vpc
            ,description="Security Group for Spark EC2 with MongoDB and Spark"
            ,allow_all_outbound=True
        )
        #Add ingress rules for security group
        sec_group.add_ingress_rule(
            peer=_ec2.Peer.any_ipv4()
            ,description="Allow Inbound Access from anywhere"
            ,connection=_ec2.Port.all_traffic())

        #Destroy the CloudWatch Logs on tear down
        sec_group.apply_removal_policy(RemovalPolicy.DESTROY)

        #Define region
        region =self.node.try_get_context("vpc_configs")["region"]

        web_server=_ec2.Instance(
            self
            ,'WebServerMongoSparkID'
            #use the free tier version for this..
            ,instance_type=_ec2.InstanceType(instance_type_identifier='t2.micro')
            ,instance_name='ec2_mongo_spark'
            ,machine_image=_ec2.MachineImage.generic_linux(
                #Ubuntu, 20.04 LTS
                #need this version for MongoDB support
                {region:'ami-08d4ac5b634553e16'}
            )
            #your personal pem key name will have to modified here..
            ,key_name=self.node.try_get_context("vpc_configs")["key_name"]
            ,vpc=def_vpc
            ,vpc_subnets=_ec2.SubnetSelection(
                subnet_type=_ec2.SubnetType.PUBLIC
            )
            ,allow_all_outbound=True
            ,security_group=sec_group
            ,user_data=_ec2.UserData.custom(install_dependencies)

        )
        #create tags for instance
        Tags.of(web_server).add('ec2SparkMongoInstance','LocalMachine')
        #return the public IP when deployed
        CfnOutput(web_server,'publicIP',value=web_server.instance_public_ip)
