#####################################################################j##########
# VPC Module Spoke VPC A Security Group
################################################################################
module "spoke_vpc_a_ssh_sg" {

  source = "terraform-aws-modules/security-group/aws//modules/ssh"


  name        = "spoke_vpc_a/security_group"
  description = "Security group for ssh  within VPC"
  vpc_id      = module.spoke_vpc_a.vpc_id

  ingress_cidr_blocks = [module.spoke_vpc_a.vpc_cidr_block,
    module.spoke_vpc_b.vpc_cidr_block,

  ]
}

module "spoke_vpc_a_https_sg" {

  source = "terraform-aws-modules/security-group/aws//modules/https-443"


  name        = "spoke_vpc_a/security_group"
  description = "Security group for https  within VPC"
  vpc_id      = module.spoke_vpc_a.vpc_id

  ingress_cidr_blocks = [module.spoke_vpc_a.vpc_cidr_block,
    module.spoke_vpc_b.vpc_cidr_block,

  ]
}


################################################################################
# VPC Module Spoke VPC B Security Group
################################################################################
module "spoke_vpc_b_ssh_sg" {

  source = "terraform-aws-modules/security-group/aws//modules/ssh"



  name        = "spoke_vpc_b/security_group-https"
  description = "Security group for ssh  within VPC"
  vpc_id      = module.spoke_vpc_b.vpc_id

  ingress_cidr_blocks = [module.spoke_vpc_a.vpc_cidr_block,
    module.spoke_vpc_b.vpc_cidr_block,
  ]
}

module "spoke_vpc_b_https_sg" {

  source = "terraform-aws-modules/security-group/aws//modules/https-443"


  name        = "spoke_vpc_b/security_group-https"
  description = "Security group for https  within VPC"
  vpc_id      = module.spoke_vpc_b.vpc_id

  ingress_cidr_blocks = [module.spoke_vpc_a.vpc_cidr_block,
    module.spoke_vpc_b.vpc_cidr_block,

  ]
}

module "spoke_vpc_b_http_sg" {

  source = "terraform-aws-modules/security-group/aws//modules/http-80"


  name        = "spoke_vpc_b/security_group-http"
  description = "Security group for HTTP within VPC"
  vpc_id      = module.spoke_vpc_b.vpc_id

  ingress_cidr_blocks = [module.spoke_vpc_a.vpc_cidr_block,
    module.spoke_vpc_b.vpc_cidr_block,

  ]
}
