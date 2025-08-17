module "db" {
  source  = "terraform-aws-modules/rds/aws"
  version = "~> 6.0"
  identifier = "${var.db_name}-${var.env}"
  engine = "postgres"
  engine_version = "16.3"
  instance_class = "db.t4g.small"
  allocated_storage = 20
  db_name  = var.db_name
  username = "app"
  port     = 5432
  family   = "postgres16"
  vpc_security_group_ids = []
  subnet_ids = var.subnets
  publicly_accessible = false
  skip_final_snapshot = true
}

output "db_endpoint" { value = module.db.db_instance_endpoint }