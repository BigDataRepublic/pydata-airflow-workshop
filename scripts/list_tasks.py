import boto3

client = boto3.client('ecs')

tasks = client.list_tasks(cluster='pydata')
tasks_desc = client.describe_tasks(cluster='pydata', tasks=tasks['taskArns'])

print(tasks_desc)