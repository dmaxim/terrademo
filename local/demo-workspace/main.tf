locals {
  organization = "mxinfo-demo"
}


resource "tfe_oauth_client" "mtc_ouath" {
  organization     = local.organization
  api_url          = "https://api.github.com"
  http_url         = "https://github.com"
  oauth_token      = var.github_token
  service_provider = "github"
}

resource "tfe_workspace" "mtc_workspace" {
  name         = github_repository.mtc_repo.name
  organization = local.organization

  vcs_repo {
    identifier     = "${var.github_owner}/${github_repository.mtc_repo.name}"
    oauth_token_id = tfe_oauth_client.mtc_ouath.oauth_token_id
  }
}

resource "tfe_variable" "aws_creds" {
  for_each     = local.aws_creds
  key          = each.key
  category     = "env"
  sensitive    = true
  workspace_id = tfe_workspace.mtc_workspace.id
  description  = "AWS Creds"
}

resource "tfe_variable" "public_key_material" {
    key = "public_key_material"
    category = "terraform"
    sensitive    = true
    workspace_id = tfe_workspace.mtc_workspace.id
    description = "Public Key for accessing git hub"
    value = file(var.public_key_path)
}