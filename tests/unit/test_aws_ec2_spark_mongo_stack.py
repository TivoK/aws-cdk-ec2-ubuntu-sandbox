import aws_cdk as core
import aws_cdk.assertions as assertions

from aws_ec2_spark_mongo.aws_ec2_spark_mongo_stack import AwsEc2SparkMongoStack

# example tests. To run these tests, uncomment this file along with the example
# resource in aws_ec2_spark_mongo/aws_ec2_spark_mongo_stack.py
def test_sqs_queue_created():
    app = core.App()
    stack = AwsEc2SparkMongoStack(app, "aws-ec2-spark-mongo")
    template = assertions.Template.from_stack(stack)

#     template.has_resource_properties("AWS::SQS::Queue", {
#         "VisibilityTimeout": 300
#     })
