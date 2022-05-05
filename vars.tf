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
    condition     = cidrsubnet(var.vpc_cidr, 3, 5) != ""
    error_message = "A larger CIDR range must be provided."
  }
}

variable "public_subnet_zones" {
  type        = list(string)
  default     = ["a", "b", "c"]
  description = "The public subnet group zones. If private_subnet_zones is set the values from that variable will be used instead and these ignored"
}

variable "additional_public_subnet_tags" {
  type        = map(string)
  default     = {}
  description = "Additional tags for public subnets."
}

variable "public_subnet_cidrs" {
  type        = map(string)
  default     = {}
  description = "Override generated CIDRs for public subnets. If specified, this list must match public_subnet_zones."
}

variable "private_subnet_zones" {
  type        = list(string)
  default     = []
  description = "The private subnet group zones"
}

variable "additional_private_subnet_tags" {
  type        = map(string)
  default     = {}
  description = "Additional tags for private subnets."
}

variable "private_subnet_cidrs" {
  type        = map(string)
  default     = {}
  description = "Override generated CIDRs for private subnets. If specified, this list must match private_subnet_zones."
}


resource "null_resource" "private_subnet_zones_check" {
  count = length(var.private_subnet_zones) > 3 ? "No more than 3 private zones can be provided." : 0
}

resource "null_resource" "public_subnet_zones_check_0" {
  count = length(var.private_subnet_zones) > 3 ? "No more than 3 public zones can be provided." : 0
}

resource "null_resource" "public_subnet_zones_check_1" {
  count = length(var.public_subnet_zones) < 1 && length(var.public_subnet_cidrs) < 1 ? "At least one public zone (or override) must be provided." : 0
}

resource "null_resource" "public_private_subnet_zones_check" {
  count = length(var.private_subnet_cidrs) > 0 && (keys(var.private_subnet_cidrs) != keys(var.public_subnet_cidrs)) ? "The same zones must be supplied when overriding CIDRs" : 0
}
