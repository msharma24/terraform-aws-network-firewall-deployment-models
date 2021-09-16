variable "region" {
  description = "AWS Region"
  type        = string
  default     = "ap-southeast-2"
}

variable "malicious_instance_type" {
  description = "AWS instance type"
  type        = string
  default     = "m5.large"
}
