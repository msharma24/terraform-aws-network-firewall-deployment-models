terraform {
  backend "s3" {
    bucket = "sls-ms-terrraform-state"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}

