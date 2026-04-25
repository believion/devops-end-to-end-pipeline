terraform {
    backend "s3" {
        bucket = "devops-tf-state-tanish"
        key = "devops-pipeline/core/terraform.tfstate"
        region = "ap-south-1"
        dynamodb_table = "terraform-locks"
        encrypt = true
    }
}