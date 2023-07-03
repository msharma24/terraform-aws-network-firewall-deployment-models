terraform {
  required_version = ">= 1.0.0"

  required_providers {

    aws = {
      version = "=5.6.1"
      source  = "hashicorp/aws"
    }

    random = {
      source  = "hashicorp/random"
      version = ">=2.3.0"
    }

    template = {
      source  = "hashicorp/template"
      version = ">=2.2.0"
    }
  }
}
