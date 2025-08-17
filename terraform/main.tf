module "network" {
  source = "./modules/network"
  project = var.project
  env = var.env
}

module "eks" {
  source = "./modules/eks"
  vpc_id = module.network.vpc_id
  private_subnet_ids = module.network.private_subnet_ids
  cluster_name = "${var.project}-${var.env}"
}

# Optional: RDS if you need SQL
module "rds" {
  source = "./modules/rds"
  vpc_id = module.network.vpc_id
  subnets = module.network.private_subnet_ids
  db_name = "app"
}

output "cluster_name" { value = module.eks.cluster_name }