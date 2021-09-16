# Centralized AWS Network Firewall Deployment Model

## Description
Centralized AWS Network Firewall Deployment Demo Infrastrcutre Using Terraform Community Open Source Models

[AWS Centralized Network Firewall Architecture Documentation]
(https://aws.amazon.com/blogs/networking-and-content-delivery/deployment-models-for-aws-network-firewall/)

## Setup
This configuration has been tested in "ap-southeast-2" and "us-east-1" region

```
terraform init
terraform plan
terraform apply -auto-approve
```


#### Notes:
[Appliance Mode Enabled on the Firewall Inspection VPC](https://aws.amazon.com/blogs/networking-and-content-delivery/centralized-inspection-architecture-with-aws-gateway-load-balancer-and-aws-transit-gateway/)
