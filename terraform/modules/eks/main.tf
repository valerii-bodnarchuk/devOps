module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"
  cluster_name = var.cluster_name
  vpc_id       = var.vpc_id
  subnet_ids   = var.private_subnet_ids
  eks_managed_node_groups = {
    default = {
      desired_capacity = 2
      min_capacity     = 2
      max_capacity     = 5
      instance_types   = ["t3.medium"]
    }
  }
}

output "cluster_name" { value = module.eks.cluster_name }