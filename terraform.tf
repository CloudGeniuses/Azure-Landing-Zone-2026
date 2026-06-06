terraform {
  required_version = ">= 1.6.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }

  # Uncomment below for Terraform Cloud backend
  # cloud {
  #   organization = "YOUR_ORG_NAME"
  #   
  #   workspaces {
  #     name = "adiryx-management-groups"
  #   }
  # }
}

provider "azurerm" {
  features {}

  # Ensure correct subscription context
  skip_provider_registration = false
}
