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

### Tests
Log in to the AWS Console after deploying the Terraform Configruation and Login to the EC2 via AWS System Manager >> Session Manager
and then you can test the firewall rules in action :-
- try to SSH to the EC2 Instance in `spoke-vpc-b` from the EC2 Instance in `spoke-vpc-a` (or vice-versa): this shouldn't work
- try to curl the private IP of the EC2 Instance in `spoke-vpc-b` from the EC2 Instance in `spoke-vpc-a` - this should work and display nginx homepage
- try to curl https://facebook.com or https://yahoo.com from either `spoke-vpc-a` or `spoke-vpc-b`-  this shouldn't work
- try a ping to a public IP address: this shouldn't work `ping 8.8.8.8`
- try to `dig` using a public DNS resolver: this shouldn't work `dig google.com`
- try to curl any other public URL: this should work

#### Notes:
[Appliance Mode Enabled on the Firewall Inspection VPC](https://aws.amazon.com/blogs/networking-and-content-delivery/centralized-inspection-architecture-with-aws-gateway-load-balancer-and-aws-transit-gateway/)
