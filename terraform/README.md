# how to not spend 1000 euros on aws credits

- https://docs.aws.amazon.com/vpc/latest/userguide/vpc-nat-gateway.html
- een private subnet kan alleen bij internet met een public iP of nat gateway
- https://serverfault.com/questions/948018/aws-nat-vs-aws-igw-vs-aws-router
- alles in 1 subnet (public). Via security groups eventueel afschermen van je services
- nat gateway is het duurst. Deze is alleen van belang als je je services zonder public IP wilt laten praten met het internet.
