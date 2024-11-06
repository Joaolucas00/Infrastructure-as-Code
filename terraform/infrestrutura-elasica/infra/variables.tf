variable "region_aws" {
  type        = string
}

variable "ssh_key" {
  type        = string
  default     = ""
  description = "ssh key for ec2"
}

variable "ec2_type" {
  type        = string
  default     = ""
  description = "type of ec2 instance"
}

variable "security_group" {
  type = string
}

variable "autoscaling_group_name" {
  type = string
}

variable "autoscaling_group_max" {
  type = number
}

variable "autoscaling_group_min" {
  type = number
}

variable "is_production" {
  type = bool
}