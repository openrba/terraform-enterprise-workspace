# Terraform Enterprise - Workspaces

## Introduction
Module for creating Terraform Enterprise workspaces and defining the appropriate variables.
This should be used with the appropriate vault configuration and orginisation modules.
<br />

<!--- BEGIN_TF_DOCS --->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| azuread | n/a |
| tfe | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| additional\_connection\_info | Map of additional connection info, output from the vault configuration module | `map(any)` | n/a | yes |
| azuread\_group\_id | Azure Active Directory group ID - to be added as workspace variable | `string` | n/a | yes |
| connection\_info | Map of connection info, output from the vault configuration module | `map(any)` | n/a | yes |
| github\_branch | GitHub branch name | `string` | n/a | yes |
| github\_oauth\_token | GitHub OAuth Token | `string` | n/a | yes |
| github\_repository | GitHub repository name | `string` | n/a | yes |
| name | Name, used for workspace name | `string` | n/a | yes |
| organization | TFE Organization | `string` | `"Infrastructure"` | no |
| ssh\_key\_id | Unique ID of the TFE SSH ID | `string` | n/a | yes |
| tfe\_endpoint | Terraform Enterprise API endpoint | `string` | `"tfe.lnrisk.io"` | no |

## Outputs

No output.

<!--- END_TF_DOCS --->