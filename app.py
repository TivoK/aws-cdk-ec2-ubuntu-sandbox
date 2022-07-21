"""AWS CloudFormation App

This is the main application file that creates and deploys the
AWS CloudFormation Stack. This leverages the following resources:

    - create_environment: Creates AWS CDK Environment Class.
    - AwsEc2SparkMongoStack: Creates CloudFormation Stack EC2 stack w/ Spark and MongoDB.
"""
#!/usr/bin/env python3
import aws_cdk as cdk
from aws_ec2_spark_mongo.aws_ec2_spark_mongo_stack import AwsEc2SparkMongoStack
from aws_ec2_spark_mongo.aws_ec2_spark_mongo_stack import create_environment

app = cdk.App()
env = create_environment()
AwsEc2SparkMongoStack(app, "MongoSparkStack", env= env)
app.synth()
