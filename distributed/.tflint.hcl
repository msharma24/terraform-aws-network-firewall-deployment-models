config {
  module = false
  force = true
  disabled_by_default = false
}

plugin "aws" {
    enabled = true
    version = "0.30.0"
    source  = "github.com/terraform-linters/tflint-ruleset-aws"
}


rule "terraform_standard_module_structure" {
    enabled = false
}



