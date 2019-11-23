import boto3
from dataclasses import dataclass
import inspect
from typing import List
import requests

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


def flatten(nested_list: list):
    return [i for k in nested_list for i in k]


lbs_resources = client.describe_load_balancers()

lbs = ALBs.from_dict(lbs_resources)


class ListenBalancer:
    lb: ALB
    endpoint: str

import time
import pandas as pd
i = sorted(lbs.LoadBalancers, key=lambda x:x.DNSName)[0]
print(i.DNSName)

listeners = client.describe_listeners(LoadBalancerArn=i.LoadBalancerArn)
listener_rules = [client.describe_rules(ListenerArn=listener['ListenerArn']) for listener in listeners['Listeners']]
rules = [j for z in listener_rules for j in z['Rules'] if j['Conditions']]
paths = [k['PathPatternConfig']['Values'] for j in rules for k in j['Conditions']]
print(rules)
print(paths)
for kk in range(1000):
    overview = {}

    for path in paths:
        for element in path:
            r = requests.get("http://" + i.DNSName + element)
            overview.update({element: r.status_code})

            if r.status_code is not 200:
                raise Exception(r, path, element)
    print(pd.DataFrame.from_dict(overview, orient='index'))
