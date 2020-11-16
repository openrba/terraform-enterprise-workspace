locals {
  access_levels = ["read", "write", "plan"]
  organization  = "Infrastructure"
  tfe_endpoint  = "tfe.lnrisk.io"
}

# Create Workspace 
resource "tfe_workspace" "workspace" {
  name         = var.name
  organization = local.organization

  vcs_repo {
    identifier     = var.github_repository
    oauth_token_id = var.github_oauth_token
  }
  
}

# Workspace Team & Access
resource "tfe_team" "workspace" {
  for_each = toset(local.access_levels)

  name         = "${var.name}-${each.key}"
  organization = local.organization
}

resource "tfe_team_access" "workspace" {
  for_each = toset(local.access_levels)

  access       = each.key
  team_id      = tfe_team.workspace[each.key].id
  workspace_id = tfe_workspace.workspace.id
}

# Team Token
resource "tfe_team_token" "workspace" {
  for_each = toset(local.access_levels)

  team_id = tfe_team.workspace[each.key].id
}

resource "tfe_variable" "team_token" {
  for_each = toset(local.access_levels)
  
  key          = "tfe_team_token_${each.key}"
  value        = tfe_team_token.workspace[each.key].token
  category     = "terraform"
  workspace_id = tfe_workspace.workspace.id
  sensitive    = true
  description  = "Terraform Enteprise Workspace - ${each.key} Team Token"
}

# Terraform Variables
resource "tfe_variable" "default_connection_info" {
  key          = "default_connection_info"
  value        = <<EOT
                  {
                    %{ for key, value in var.connection_info ~}
                    ${key} = "${value}"
                    %{ endfor ~}
                  }
                  EOT
  category     = "terraform"
  workspace_id = tfe_workspace.workspace.id
  sensitive    = true
  hcl          = true
  description  = "Default vault credentials to be used for azure"
}

resource "tfe_variable" "tfe_workspace_name" {
  key          = "tfe_workspace_name"
  value        = var.name
  category     = "terraform"
  workspace_id = tfe_workspace.workspace.id
  sensitive    = false
  description  = "Terraform Enterprise workspace name"
}

resource "tfe_variable" "tfe_workspace_org" {
  key          = "tfe_workspace_org"
  value        = local.organization
  category     = "terraform"
  workspace_id = tfe_workspace.workspace.id
  sensitive    = false
  description  = "Terraform Enterprise workspace organization"
}

resource "tfe_variable" "tfe_endpoint" {
  key          = "tfe_endpoint"
  value        = local.tfe_endpoint
  category     = "terraform"
  workspace_id = tfe_workspace.workspace.id
  sensitive    = false
  description  = "Terraform Enterprise endpoint"
}

# Environment Variables
resource "tfe_variable" "tenant_id" {
  key          = "ARM_TENANT_ID"
  value        = var.connection_info.tenant_id
  category     = "env"
  workspace_id = tfe_workspace.workspace.id
  sensitive    = false
  description  = "Azure Tenant ID"
}

resource "tfe_variable" "subscription_id" {
  key          = "ARM_SUBSCRIPTION_ID"
  value        = var.connection_info.subscription_id
  category     = "env"
  workspace_id = tfe_workspace.workspace.id
  sensitive    = false
  description  = "Azure Subscription ID"
}