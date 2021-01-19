variable "name" {
  description = "Name, used for workspace name"
  type        = string
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

# Connection Details
variable "connection_info" { 
  description = "Map of connection info, output from the vault configuration module"
  type        = map
}

variable "additional_connection_info" { 
  description = "Map of additional connection info, output from the vault configuration module"
  type        = map
}