provider "aws" {
  region = "ap-south-1"
}

module "ec2" {
  source = "../../modules/ec2"

  instance_type    = "t3.micro"
  instance_profile = var.instance_profile_name
  public_key_path  = var.public_key_path
}