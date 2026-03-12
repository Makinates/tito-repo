output "cloudfront_url" {
  value = "https://${module.aws_cloud.cloudfront_url}"
}

output "azure_website_url" {
  value = "https://${module.azure_cloud.azure_static_web_app_url}"
}
