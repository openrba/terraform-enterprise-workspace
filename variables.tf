variable "tfe_endpoint" {
  description = "Terraform Enterprise API endpoint"
  type        = string
  default     = "tfe.lnrisk.io"
}

variable "name" {
  description = "Name, used for workspace name"
  type        = string
}

variable "organization" {
  description = "TFE Organization"
  type        = string
  default     = "Infrastructure"
}

# GitHub
variable "github_repository" {
  description = "GitHub repository name"
  type        = string
}

variable "github_branch" {
  description = "GitHub branch name"
  type        = string
}

variable "github_oauth_token" {
  description = "GitHub OAuth Token"
  type        = string
}

variable "ssh_key_id" {
  description = "Unique ID of the TFE SSH ID"
  type        = string
}

# Connection Details
variable "connection_info" {
  description = "Map of connection info, output from the vault configuration module"
  type        = map(any)
}

variable "additional_connection_info" {
  description = "Map of additional connection info, output from the vault configuration module"
  type        = map(any)
}

# AAD Group
variable "azuread_group_id" {
  description = "Azure Active Directory group ID - to be added as workspace variable"
  type        = string
}