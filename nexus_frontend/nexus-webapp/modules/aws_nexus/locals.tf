locals {
  site_files = fileset(var.site_path, "**")

  mime_types = {
    ".html" = "text/html"
    ".css"  = "text/css"
    ".js"   = "application/javascript"
  }
}
