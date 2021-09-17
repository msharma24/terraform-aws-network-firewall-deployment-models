# AWS Network Firewall  Deployment models using Terraform

# Info
This project contains Terraform resources to deploy
[AWS Network Firewall](https://aws.amazon.com/network-firewall/?whats-new-cards.sort-by=item.additionalFields.postDateTime&whats-new-cards.sort-order=desc)
with the following  Architecture Models.

- Distributed
- Centralised

AWS has published detailed blog posts about the Network Firewall Architectures
[Deployment models for AWS Network Firewall](https://aws.amazon.com/blogs/networking-and-content-delivery/deployment-models-for-aws-network-firewall/)

### 1. Distributed

For the distributed deployment model, we deploy AWS Network Firewall into each
VPC which requires protection. Each VPC is protected individually and blast
radius is reduced through VPC isolation. Each VPC does not require connectivity
to any other VPC or AWS Transit Gateway. Each AWS Network Firewall can have its
own firewall policy or share a policy through common rule groups
(reusable collections of rules) across multiple firewalls.

### 2. Centralised

For centralized deployment model, AWS Transit Gateway is a prerequisite. AWS Transit Gateway acts as a network hub and simplifies the connectivity between VPCs as well as on-premises networks. AWS Transit Gateway also provides inter-region peering capabilities to other Transit Gateways to establish a global network using AWS backbone.


### Directory Structure
```
terraform-aws-network-firewall-deployment-models
├── centralized  - Terraform resources to deploy the Centralised Deployment Model
└── distributed - Terraform resources to deploy the Distributed Deployment Model

