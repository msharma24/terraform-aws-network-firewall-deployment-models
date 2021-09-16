variable "environment" {
  description = "Deployment environment name"
  type        = string
  default     = "dev"
}

variable "region" {
  description = "AWS Deployment region"
  type        = string
  default     = "ap-southeast-2"
}
