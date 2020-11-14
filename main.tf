# Create Workspace 
resource "tfe_workspace" "workspace" {
  name         = var.name
  organization = "Infrastructure"

  vcs_repo {
    identifier     = var.github_repository
    oauth_token_id = var.github_oauth_token
  }
  
}

# Terraform Variables
resource "tfe_variable" "vault_token" {
  key          = "vault_token"
  value        = var.connection_info.vault_token
  category     = "terraform"
  workspace_id = tfe_workspace.workspace.id
  sensitive    = true
  description  = "Vault token to be used for azure credentials"
}

resource "tfe_variable" "vault_path" {
  key          = "vault_azure_credential_path"
  value        = var.connection_info.vault_backend
  category     = "terraform"
  workspace_id = tfe_workspace.workspace.id
  sensitive    = false
  description  = "Vault path to azure credentials"
}

resource "tfe_variable" "vault_role" {
  key          = "vault_role"
  value        = var.connection_info.vault_role
  category     = "terraform"
  workspace_id = tfe_workspace.workspace.id
  sensitive    = false
  description  = "Vault path to azure credentials"
}

# Environment Variables
resource "tfe_variable" "tenant_id" {
  key          = "ARM_TENANT_ID"
  value        = var.connection_info.vault_role
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