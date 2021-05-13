# Scylla load test demo
This repository contains CloudFormation templates and supporting files to run an automated load test on a Scylla Cloud cluster for demo purposes.

There are two CloudFormation templates:
1. VPC stack - VPC, subnet, routing table etc.
2. Workers stack - EC2 instances running the load test
In order to run the load test in a secure manner private VPC IP addresses are uses which means that VPC peering is required. VPC stack is separate so you can run it, peer it with Scylla cloud and then run the workers stack as needed to generate load.

# Running
## VPC stack
Using the CLI:
```
aws cloudformation create-stack --stack-name test-stress-vpc --template-body file://./stress-vpc.cfn.yaml
```
When done, the stack will have outputs with the needed parameters for VPC peering with Scylla cloud: VPC ID, Account ID, VPC CIDR block. Configure the peering as explained in Scylla cloud (also, see the [docs](https://docs.scylladb.com/scylla-cloud/cloud-setup/vpc-peering/)).

## Workers stack
Using the CLI:
```
aws cloudformation create-stack --stack-name test-scylla-workers --template-body file://./stress-workers.cfn.yaml --parameters file://./workers-params.json
```

The stack requires the following parameters:
- `SSHKeyName` - SSH key already imported to EC2, used for SSH debugging access to workers
- `VPCStackName` - The name you used for the VPC stack, e.g. `test-stress-vpc`
- `ScyllaNodes` - A list of Scylla cloud nodes private IPs, copy pasted from the Scylla cloud "Connect" tab
- `ScyllaPassword` - The password of the `scylla` user, copy pasted from the Scylla cloud "Connect" tab

The stack will create 4 EC2 instances which will automatically start generating load on the cluster.