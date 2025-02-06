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
    count = "${length(data.aws_availability_zones.vailable.names)}"
    vpc_id = aws_vpc.v21qw1.id
    cidr_block = "10.64.${count.index}.0/24"
    map_public_ip_on_launch = "true"
    availability_zone = "${element(data.aws_availability_zones.vailable.names,count.index)}"

    tags = {
         Name = "public-${element(data.aws_availability_zones.vailable.names, count.index)}"
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