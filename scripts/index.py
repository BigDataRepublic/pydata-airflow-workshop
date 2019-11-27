import boto3
from dataclasses import dataclass
import inspect
from typing import List
import requests
import pandas as pd

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


loadbalancers = sorted(lbs.LoadBalancers, key=lambda x: x.DNSName)


def get_rules_with_conditions(listeners):
    listener_rules = [client.describe_rules(ListenerArn=listener_['ListenerArn']) for listener_ in
                      listeners['Listeners']]
    return [j for z in listener_rules for j in z['Rules'] if j['Conditions']]


listeners = [(i, client.describe_listeners(LoadBalancerArn=i.LoadBalancerArn)) for i in loadbalancers]
rules_with_cond = [(key, get_rules_with_conditions(value)) for (key, value) in listeners]

rules = [(lb, rule) for (lb, rule_list) in rules_with_cond for rule in rule_list]
lb_conditions = [(lb, rule['Conditions']) for (lb, rule) in rules]

lb_endpoints = [(lb, flatten([i['Values'] for i in rule])) for (lb, rule) in lb_conditions]
lb_endpoints_flat = [(lb, endpoint) for (lb, endpoint_list) in lb_endpoints for endpoint in endpoint_list]

for kk in range(1000):
    overview = {}
    while True:
        for lb, endpoint in lb_endpoints_flat:
            r = requests.get("http://" + lb.DNSName + endpoint)
            overview.update({endpoint: r.status_code})
            print(lb.DNSName, endpoint, r.status_code)

            if r.status_code is not 200:
                raise Exception(r, lb.DNSName, endpoint)
        print(pd.DataFrame.from_dict(overview, orient='index').describe())
