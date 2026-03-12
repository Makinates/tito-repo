terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
}

provider "aws" {
  region = var.region
}

provider "azurerm" {
  features {}
}

