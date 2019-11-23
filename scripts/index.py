import boto3
from dataclasses import dataclass
import inspect
from typing import List

client = boto3.client('elbv2')

@dataclass
class BaseClass:
    @classmethod
    def from_dict(cls, env):
        return cls(**{
            k: v for k, v in env.items()
            if k in inspect.signature(cls).parameters
        })

@dataclass
class ALB(BaseClass):
    DNSName: str
    LoadBalancerArn: str

@dataclass
class ALBs(BaseClass):
    LoadBalancers: List[ALB]

    def __post_init__(self):
        self.LoadBalancers = [ALB.from_dict(i) for i in self.LoadBalancers]

@dataclass
class Listener(BaseClass):
    pass


class ListenerRule(BaseClass):
    pass


lbs_resources = client.describe_load_balancers()

lbs = ALBs.from_dict(lbs_resources)

listeners = [client.describe_listeners(LoadBalancerArn=i.LoadBalancerArn) for i in lbs.LoadBalancers]
listener_rules = [client.describe_rules(ListenerArn=arn['ListenerArn']) for i in listeners for arn in i['Listeners']]

a = 1
[j['Conditions'] for i in listener_rules for j in i['Rules'] if j['Conditions']]
# get loadbalancers
# get rules at port 80
#