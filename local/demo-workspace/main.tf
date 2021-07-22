locals {
  organization = "seti-demo"
}


resource "tfe_oauth_client" "demo_client" {
  organization     = local.organization
  api_url          = "https://api.github.com"
  http_url         = "https://github.com"
  oauth_token      = var.github_token
  service_provider = "github"
}

resource "tfe_workspace" "demo_workspace" {
  name              = var.tf_workspace_name
  organization      = local.organization
  working_directory = var.repository_working_directory
  vcs_repo {
    identifier     = "${var.github_owner}/${var.github_demo_repository}"
    oauth_token_id = tfe_oauth_client.demo_client.oauth_token_id
  }
}


resource "tfe_variable" "variable" {
  for_each     = local.variables
  key          = each.key
  category     = "terraform"
  sensitive    = each.value.sensitive
  workspace_id = tfe_workspace.demo_workspace.id
  description  = each.value.description
  value        = each.value.value
}