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