module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "my-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["eu-west-3a", "eu-west-3b", "eu-west-3c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false
  enable_vpn_gateway     = false

  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Terraform   = "true"
    Environment = "dev"

  }
  private_subnet_tags = {
    "kubernetes.io/cluster/kubernetes-sec-2" = "shared"
    "kubernetes.io/role/elb"               = 1
  }
  public_subnet_tags = {
    "kubernetes.io/role/internal-elb"      = 1
    "kubernetes.io/cluster/kubernetes-sec-2" = "shared"
  }
}
