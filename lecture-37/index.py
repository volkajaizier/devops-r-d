import boto3
import json

ses = boto3.client('ses')

def lambda_handler(event, context):
    print('Received event:', json.dumps(event, indent=2))
    
    for record in event['Records']:
        if record['eventName'] == 'INSERT':
            new_item = record['dynamodb']['NewImage']
            email = new_item['email']['S']
            name = new_item['name']['S']

            send_email(email, name)

def send_email(email, name):
    try:
        response = ses.send_email(
            Source='your-verified-email@example.com',
            Destination={'ToAddresses': [email]},
            Message={
                'Subject': {'Data': 'Welcome Email'},
                'Body': {'Text': {'Data': f'Hello {name}, welcome to our service!'}}
            }
        )
        print(f"Email sent to {email}")
    except Exception as e:
        print(f"Error sending email to {email}: {str(e)}")
