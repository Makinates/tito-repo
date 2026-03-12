output "azure_static_web_app_url" {
  value = azurerm_static_web_app.site.default_host_name
}