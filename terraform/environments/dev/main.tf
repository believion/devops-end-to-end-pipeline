data "terraform_remote_state" "core" {
  backend = "s3"
  
   config = {
    bucket = "devops-tf-state-tanish"
    key    = "devops-pipeline/core/terraform.tfstate"
    region = "ap-south-1"
  }
}

provider "aws" {
  region = "ap-south-1"
}

module "ec2" {
  source = "../../modules/ec2"

  instance_type    = "t3.micro"
  instance_profile = data.terraform_remote_state.core.outputs.instance_profile_name
  public_key_path  = var.public_key_path
}