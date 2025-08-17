terraform {
  backend "s3" {
    bucket = "val-tf-state"
    key    = "devops-starter/terraform.tfstate"
    region = "eu-central-1"
    dynamodb_table = "val-tf-locks"
    encrypt = true
  }
}