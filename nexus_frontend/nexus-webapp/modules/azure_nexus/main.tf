resource "azurerm_resource_group" "res_group" {
  name     = var.resource_group_name #"NexusFrontend"
  location = var.azure_location            #uksouth
}


resource "azurerm_static_web_app" "site" {
  name                = var.static_web_name
  resource_group_name = azurerm_resource_group.res_group.name
  location            = azurerm_resource_group.res_group.location
  repository_url      = var.repo_url
  repository_branch   = var.repo_branch
  repository_token    = var.github_token


  tags = {
    environment = "staging"
  }
}
