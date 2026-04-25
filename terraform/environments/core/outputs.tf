output "ecr_repository_url" {
  value = module.ecr.repository_url
}

output "instance_profile_name" {
  value = module.iam.instance_profile_name
}