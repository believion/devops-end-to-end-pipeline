provider "aws" {
  region = "ap-south-1"
}

module "ecr" {
  source = "../../modules/ecr"
  repo_name = "devops-pipeline"
}

module "iam" {
  source = "../../modules/iam"
}

module "ec2" {
  source = "../../modules/ec2"

  instance_type    = "t3.micro"
  instance_profile = module.iam.instance_profile_name
  public_key_path  = "/home/tanish/.ssh/devops-key.pub"
}