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
  validation {
    condition     = length(var.public_subnet_zones) <= 3
    error_message = "No more than 3 public zones can be provided."
  }
  validation {
    condition     = length(var.public_subnet_zones) > 0
    error_message = "At least one public zone must be provided."
  }
}

variable "additional_public_subnet_tags" {
  type        = map(any)
  default     = {}
  description = "Additional tags for public subnets."
}

variable "public_subnet_cidrs" {
  type        = list(string)
  default     = []
  description = "Override generated CIDRs for public subnets. If specified, this list must match public_subnet_zones."
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

variable "additional_private_subnet_tags" {
  type        = map(any)
  default     = {}
  description = "Additional tags for private subnets."
}

variable "private_subnet_cidrs" {
  type        = list(string)
  default     = []
  description = "Override generated CIDRs for private subnets. If specified, this list must match private_subnet_zones."
}
