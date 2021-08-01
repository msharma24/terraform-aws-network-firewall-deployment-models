terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      version = ">= 3.52.0"
      source  = "hashicorp/aws"
    }
    random = {
      source  = "hashicorp/random"
      version = ">=2.3.0"
    }
  }
}
