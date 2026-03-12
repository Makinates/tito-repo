module "aws_cloud" {
  source       = "./modules/aws_nexus"
  project_name = var.project_name
  bucket_name  = var.bucket_name
  site_path    = var.site_path
}


module "azure_cloud" {
  source              = "./modules/azure_nexus"
  repo_branch         = var.repo_branch
  static_web_name     = var.static_web_name
  repo_url            = var.repo_url
  resource_group_name = var.resource_group_name
  azure_location      = var.azure_location
  github_token        = var.github_token
}
