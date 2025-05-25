import boto3
import os

def get_ssm_parameter(name):
    ssm = boto3.client("ssm")
    response = ssm.get_parameter(Name=name, WithDecryption=True)
    return response["Parameter"]["Value"]

def lambda_handler(event, context):
    param_name = os.environ.get("DB_PASSWORD_PARAM", "/spp-db/password")
    password = get_ssm_parameter(param_name)

    return {
        "statusCode": 200,
        "body": f"Password is: {password}"
    }
