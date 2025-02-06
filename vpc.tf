# module "vpc" {
#   source  = "terraform-aws-modules/vpc/aws"
#   version = "5.8.1"

#   name = "eks-tf-githubactions-vpc"

#   cidr = "10.224.0.0/16"
#   azs  = slice(data.aws_availability_zones.available.names, 0, 2)

#   private_subnets = ["10.224.16.0/24", "10.224.24.0/24"]
#   public_subnets  = ["10.224.20.0/24", "10.224.28.0/24"]

#   enable_nat_gateway   = true
#   single_nat_gateway   = true
#   enable_dns_hostnames = true

#   public_subnet_tags = {
#     "kubernetes.io/role/elb" = 1
#   }

#   private_subnet_tags = {
#     "kubernetes.io/role/internal-elb" = 1
#   }
# }



resource "aws_vpc" "v21qw1" {
    cidr_block = "10.224.0.0/16"
    enable_dns_support = "true"
    enable_dns_hostnames = "true"
    tags = {
         Name = "v21qw1"
    }
}
# resource "aws_vpc" "v21qe1" {
#     provider = aws.us-east
#     cidr_block = "10.128.0.0/16"
#     enable_dns_support = "true"
#     enable_dns_hostnames = "true"
#     tags = {
#          Name = "v21qe1"
#     }
# }

resource "aws_subnet" "westwebsub" {
    count = "${length(data.aws_availability_zones.available.names)}"
    vpc_id = aws_vpc.v21qw1.id
    cidr_block = "10.224.${count.index}.0/24"
    map_public_ip_on_launch = "false"
    availability_zone = "${element(data.aws_availability_zones.available.names,count.index)}"

    tags = {
         Name = "public-${element(data.aws_availability_zones.available.names, count.index)}"
    }
}

# resource "aws_subnet" "eastwebsub" {
#     count = "${length(data.aws_availability_zones.eastzone.names)}"
#     vpc_id = aws_vpc.v21qe1.id
#     provider = aws.us-east
#     cidr_block = "10.128.${count.index}.0/24"
#     map_public_ip_on_launch = "true"
#     availability_zone = "${element(data.aws_availability_zones.eastzone.names,count.index)}"

#     tags = {
#          Name = "public-${element(data.aws_availability_zones.eastzone.names, count.index)}"
#     }
# }

# VPC flow logs
resource "aws_s3_bucket" "vpc_flow_logs" {
  bucket = "vpc-flow-logs-book"

  versioning {
    enabled = true
  }

  logging {
        target_bucket = "terraform-albert1"
    }

  lifecycle {
    prevent_destroy = true
  }

  server_side_encryption_configuration {
     rule {
       apply_server_side_encryption_by_default {
         kms_master_key_id = "arn"
         sse_algorithm     = "aws:kms"
       }
     }
   }
}

resource "aws_s3_bucket_public_access_block" "vpc_flow_logs" {
  bucket = aws_s3_bucket.vpc_flow_logs.id
  block_public_acls = true
  block_public_policy = true 
  ignore_public_acls = true
  restrict_public_buckets = true
}

resource "aws_flow_log" "appsec-preprod" {
  log_destination      = aws_s3_bucket.vpc_flow_logs.arn
  log_destination_type = "s3"
  traffic_type         = "ALL"
  vpc_id               = aws_vpc.v21qw1.id

  # Enable the new meta fields
  log_format = "$${version} $${vpc-id} $${subnet-id} $${instance-id} $${interface-id} $${account-id} $${type} $${srcaddr} $${dstaddr} $${srcport} $${dstport} $${protocol} $${packets} $${bytes} $${start} $${end} $${action} $${tcp-flags}"

  tags = {
    Name = "vpc_flow_logs"
  }
}
