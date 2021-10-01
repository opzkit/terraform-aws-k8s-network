variable "name" {
  type        = string
  description = "Name of the created VPC"
}

variable "region" {
  type        = string
  description = "Name of AWS region to use for cluster"
}

variable "vpc_cidr" {
  type        = string
  default     = "172.20.0.0/16"
  description = "CIDR range for the VPC?"
  validation {
    condition     = cidrsubnet(var.vpc_cidr, 3, 5 + var.subnet_cidrs_offset) != ""
    error_message = "A larger CIDR range must be provided."
  }
}

variable "subnet_cidrs_offset" {
  type        = number
  default     = 1
  description = "Offset into the CIDR generation. Can be useful if you don't want your subnet CIDRs to start at x.x.0.0/19."
}

variable "public_subnet_zones" {
  type        = list(string)
  default     = ["a", "b", "c"]
  description = "The public subnet group zones. If private_subnet_zones is set the values from that variable will be used instead and these ignored"
  validation {
    condition     = length(var.public_subnet_zones) <= 3
    error_message = "No more than 3 public zones can be provided."
  }
  validation {
    condition     = length(var.public_subnet_zones) > 0
    error_message = "At least one public zone must be provided."
  }
}

variable "private_subnet_zones" {
  type        = list(string)
  default     = []
  description = "The private subnet group zones"
  validation {
    condition     = length(var.private_subnet_zones) <= 3
    error_message = "No more than 3 private zones can be provided."
  }
}
