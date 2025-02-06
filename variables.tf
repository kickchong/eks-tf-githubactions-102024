# variable "region" {
#   description = "AWS region"
#   type        = string
#   default     = "us-west-1"
# }

data "aws_availability_zones" "available" {
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}


variable "appname" {
  type        = string
  default     = "hellome"
}
