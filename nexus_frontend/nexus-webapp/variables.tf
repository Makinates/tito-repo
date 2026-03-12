variable "region" {
  type        = string
  description = "AWS deployment region"
  default     = "eu-west-1"
}

variable "azure_location" {
  type        = string
  description = "Azure deployment region"
  default     = "uksouth"
}

variable "deploy_aws" {
  type    = bool
  default = true
}

variable "deploy_azure" {
  type    = bool
  default = true
}

variable "bucket_name" {
  type = string
}


variable "project_name" {
  type = string
}

variable "site_path" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "static_web_name" {
  type = string
}


variable "repo_url" {
  type = string
}

variable "repo_branch" {
  type = string
}

variable "github_token" {
  type = string
}
