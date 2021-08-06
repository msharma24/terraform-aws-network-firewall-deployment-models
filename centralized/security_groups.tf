################################################################################
# VPC Module Spoke VPC A Security Group
################################################################################
module "spoke_vpc_a_ssh_sg" {

  source = "terraform-aws-modules/security-group/aws//modules/ssh"


  name        = "spoke_vpc_a/security_group"
  description = "Security group for ssh  within VPC"
  vpc_id      = module.spoke_vpc_a.vpc_id

  ingress_cidr_blocks = [module.spoke_vpc_a.vpc_cidr_block,
    module.spoke_vpc_b.vpc_cidr_block,
    "0.0.0.0/0"

  ]
}


################################################################################
# VPC Module Spoke VPC B Security Group
################################################################################
module "spoke_vpc_b_ssh_sg" {

  source = "terraform-aws-modules/security-group/aws//modules/ssh"



  name        = "spoke_vpc_b/security_group"
  description = "Security group for ssh  within VPC"
  vpc_id      = module.spoke_vpc_b.vpc_id

  ingress_cidr_blocks = [module.spoke_vpc_a.vpc_cidr_block,
    module.spoke_vpc_b.vpc_cidr_block,
    "0.0.0.0/0"
  ]
}




