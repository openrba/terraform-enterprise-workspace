locals {
  access_levels = ["read", "write"]
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
    branch         = var.github_branch
  }
  
}

# Azure AD Group
data "azuread_service_principal" "group_owner" {
  display_name = "ris-azr-app-infrastructure-terraformenterprise-aad-group-owner"
}

data "azuread_service_principal" "ad_sync" {
  display_name = "ris-azr-app-infrastructure-guestsync"
}

resource "azuread_group" "team" {
  for_each = toset(local.access_levels)

  display_name            = "ris-azr-group-tfe-${var.name}-${each.key}"
  owners                  = [
    data.azuread_service_principal.group_owner.id, 
    data.azuread_service_principal.ad_sync.id
  ]
  prevent_duplicate_names = true
}

# Workspace Team & Access
resource "tfe_team" "workspace" {
  for_each = toset(local.access_levels)

  name         = azuread_group.team[each.key].id
  organization = local.organization
  visibility   = "organization"
}

resource "tfe_team_access" "workspace" {
  for_each = toset(local.access_levels)

  access       = each.key
  team_id      = tfe_team.workspace[each.key].id
  workspace_id = tfe_workspace.workspace.id
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

resource "tfe_variable" "additional_connection_info" {
  for_each = var.additional_connection_info

  key          = "${each.key}_connection_info_$"
  value        = <<EOT
                  {
                    %{ for key, value in each.value ~}
                    ${key} = "${value}"
                    %{ endfor ~}
                  }
                  EOT
  category     = "terraform"
  workspace_id = tfe_workspace.workspace.id
  sensitive    = true
  hcl          = true
  description  = "Additional vault credentials to be used for azure"
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

# GitHub Repository
resource "tfe_variable" "github_branch" {
  key          = "github_branch"
  value        = var.github_branch
  category     = "terraform"
  workspace_id = tfe_workspace.workspace.id
  sensitive    = false
  description  = "Terraform Enterprise endpoint"
}

resource "tfe_variable" "github_repository" {
  key          = "github_repository"
  value        = var.github_repository
  category     = "terraform"
  workspace_id = tfe_workspace.workspace.id
  sensitive    = false
  description  = "Terraform Enterprise endpoint"
}