# module "eks" {
#   source  = "terraform-aws-modules/eks/aws"
#   version = "20.31.1"

#   cluster_name    = "kubernetes-sec"
#   cluster_version = "1.31"

#   # Optional
#   cluster_endpoint_public_access  = true
#   cluster_endpoint_private_access = true

#   # Optional: Adds the current caller identity as an administrator via cluster access entry
#   enable_cluster_creator_admin_permissions = true

#   cluster_compute_config = {
#     enabled    = true
#     node_pools = ["general-purpose"]
#   }

#   vpc_id     = module.vpc.vpc_id
#   subnet_ids = module.vpc.private_subnets

#   enable_irsa = true

#   eks_managed_node_groups = {
#     general-purpose = {
#       # Starting on 1.30, AL2023 is the default AMI type for EKS managed node groups
#       instance_types = ["t3.medium"]
#       capacity_type  = "ON_DEMAND"

#       min_size     = 2
#       max_size     = 10
#       desired_size = 2

#       labels = {
#         role = "general"
#       }
#     }
#   }

#   cluster_addons = {
#     coredns = {
#       most_recent = true
#     }

#     vpc-cni = {
#       most_recent = true
#     }

#     kube-proxy = {
#       most_recent = true
#     }
#   }
# }

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.31.1"

  cluster_name    = "kubernetes-sec-2"
  cluster_version = "1.31"

  cluster_endpoint_public_access           = true
  enable_cluster_creator_admin_permissions = true

#   cluster_addons = {
#     aws-ebs-csi-driver = {
#       service_account_role_arn = module.irsa-ebs-csi.iam_role_arn
#     }
#   }

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  eks_managed_node_group_defaults = {
    ami_type = "AL2_x86_64"

  }

  eks_managed_node_groups = {
    one = {
      name = "node-group-1"

      instance_types = ["t3.small"]

      min_size     = 1
      max_size     = 3
      desired_size = 2
    }

    two = {
      name = "node-group-2"

      instance_types = ["t3.small"]

      min_size     = 1
      max_size     = 2
      desired_size = 1
    }
  }
}


# # https://aws.amazon.com/blogs/containers/amazon-ebs-csi-driver-is-now-generally-available-in-amazon-eks-add-ons/ 
# data "aws_iam_policy" "ebs_csi_policy" {
#   arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
# }

# module "irsa-ebs-csi" {
#   source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"

#   create_role                   = true
#   role_name                     = "AmazonEKSTFEBSCSIRole-${module.eks.cluster_name}"
#   provider_url                  = module.eks.oidc_provider
#   role_policy_arns              = [data.aws_iam_policy.ebs_csi_policy.arn]
#   oidc_fully_qualified_subjects = ["system:serviceaccount:kube-system:ebs-csi-controller-sa"]
# }
