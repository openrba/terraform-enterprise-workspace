variable "name" {
  description = "Name, used for workspace name"
  type        = string
}

# GitHub
variable "github_repository" { 
  description = "Azure tenant ID, stored as environment variable in workspace"
  type        = string
}

variable "github_oauth_token" {
  description = "GitHub OAuth Token"
  type        = string

}

# Connection Details
variable "connection_info" { 
  description = "Map of connection info, output from the vault configuration module"
  type        = map
}

variable "additional_connection_info" { 
  description = "Map of additional connection info, output from the vault configuration module"
  type        = map
}