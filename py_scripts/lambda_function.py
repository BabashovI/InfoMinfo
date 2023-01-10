import boto3

ec2 = boto3.client('ec2')

name = "bot_server"


def ec2_info():
    try:
        response = ec2.describe_instances(
            Filters=[
                {
                    'Name': "tag:Name",
                    'Values': ['bot_server',]
                },
                {
                    'Name': "instance-state-name",
                    'Values': ["running", "stopped",]
                },
            ]
        )
        return [
            ids['InstanceId'] for ids in response['Reservations'][0]['Instances']
        ]
    except IndexError:
        return "NO instance with name bot_server"


def lambda_handler(event, context):
    a = ec2_info()

    if 'i-' not in a:
        return "no instance available"

    if event['action'] == 'stop':
        ec2.stop_instances(InstanceIds=a)
    if event['action'] == 'start':
        ec2.start_instances(InstanceIds=a)
    return "DONE"
