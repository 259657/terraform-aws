import json
import math
import boto3
import os
from datetime import datetime

def mark_sensor_as_broken(sensor_id):
    dynamodb = boto3.resource('dynamodb')
    table = dynamodb.Table(os.environ["DYNAMODB_TABLE_NAME"])
    table.put_item(
        Item={
            'sensor_id': sensor_id,
            'broken': True
        }
    )

def send_sns_notification(message):
    sns_client = boto3.client("sns", region_name="us-east-1")  
    topic_arn = os.environ["SNS_TOPIC_ARN"]
    sns_client.publish(
        TopicArn=topic_arn,
        Message=message,
        Subject="Temperature Alert"
    )

def send_to_sqs(sensor_id, location_id, temperature):
    sqs_client = boto3.client("sqs", region_name="us-east-1")
    queue_url = os.environ["SQS_QUEUE_URL"]
    
    timestamp = datetime.utcnow().strftime("%Y-%m-%d %H:%M:%S")
    
    sensor_data = {
        "sensor_id": sensor_id,
        "location_id": location_id,
        "temperature": temperature,
        "timestamp": timestamp
    }
    
    response = sqs_client.send_message(
        QueueUrl=queue_url,
        MessageBody=json.dumps(sensor_data)
    )
    return response

def lambda_handler(event, context):
    try:
        sensor_id = event.get("sensor_id")
        location_id = event.get("location_id")
        resistance = event.get("value")

        if not (1 <= resistance <= 20000):
            mark_sensor_as_broken(sensor_id)
            return {
                "statusCode": 400,
                "body": json.dumps({"error": "VALUE OUT OF RANGE"})
            }
        print("anowassdasddasdasdasy")
        a = 1.40e-3
        b = 2.37e-4
        c = 9.90e-8

        lnR = math.log(resistance)
        T_inv = a + (b * lnR) + (c * lnR**3)
        T_K = 1 / T_inv
        T_C = T_K - 273.15

        if T_C < -273.15:
            status = "VALUE OUT OF RANGE"
        elif -273.15 <= T_C < 20:
            status = "TEMPERATURE TOO LOW"
        elif 20 <= T_C < 100:
            status = "OK"
        elif 100 <= T_C < 250:
            status = "TEMPERATURE TOO HIGH"
        else:
            status = "TEMPERATURE CRITICAL"
            send_sns_notification(f"Critical temperature detected: {T_C:.2f}°C")
            mark_sensor_as_broken(sensor_id)

        send_to_sqs(sensor_id, location_id, T_C)

        return {
            "statusCode": 200,
            "body": json.dumps({"status": status})
        }
    except Exception as e:
        return {
            "statusCode": 500,
            "body": json.dumps({"error": str(e)})
        }
