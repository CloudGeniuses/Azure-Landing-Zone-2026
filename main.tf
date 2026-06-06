terraform {
  required_version = ">= 1.6.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {}
}

locals {
  subscription_id = "/subscriptions/ff45ede4-ddf8-4818-9ab0-486b2d42d71e"
}

#################################################
# ADIRYX ROOT MANAGEMENT GROUP
#################################################

resource "azurerm_management_group" "adiryx" {
  name         = "adiryx"
  display_name = "Adiryx"
}

#################################################
# PLATFORM MANAGEMENT GROUPS
#################################################

resource "azurerm_management_group" "platform" {
  name                       = "adiryx-platform"
  display_name               = "Adiryx Platform"
  parent_management_group_id = azurerm_management_group.adiryx.id
}

resource "azurerm_management_group" "identity" {
  name                       = "adiryx-identity"
  display_name               = "Adiryx Identity"
  parent_management_group_id = azurerm_management_group.platform.id
}

resource "azurerm_management_group" "connectivity" {
  name                       = "adiryx-connectivity"
  display_name               = "Adiryx Connectivity"
  parent_management_group_id = azurerm_management_group.platform.id
}

resource "azurerm_management_group" "management" {
  name                       = "adiryx-management"
  display_name               = "Adiryx Management"
  parent_management_group_id = azurerm_management_group.platform.id
}

#################################################
# LANDING ZONES MANAGEMENT GROUPS
#################################################

resource "azurerm_management_group" "landingzones" {
  name                       = "adiryx-landingzones"
  display_name               = "Adiryx Landing Zones"
  parent_management_group_id = azurerm_management_group.adiryx.id
}

resource "azurerm_management_group" "prod" {
  name                       = "adiryx-prod"
  display_name               = "Adiryx Production"
  parent_management_group_id = azurerm_management_group.landingzones.id
}

resource "azurerm_management_group" "nonprod" {
  name                       = "adiryx-nonprod"
  display_name               = "Adiryx Non-Production"
  parent_management_group_id = azurerm_management_group.landingzones.id
}

resource "azurerm_management_group" "sandbox" {
  name                       = "adiryx-sandbox"
  display_name               = "Adiryx Sandbox"
  parent_management_group_id = azurerm_management_group.landingzones.id
}

#################################################
# DECOMMISSIONED MANAGEMENT GROUP
#################################################

resource "azurerm_management_group" "decommissioned" {
  name                       = "adiryx-decommissioned"
  display_name               = "Adiryx Decommissioned"
  parent_management_group_id = azurerm_management_group.adiryx.id
}

#################################################
# SUBSCRIPTION ASSOCIATION
#################################################

resource "azurerm_management_group_subscription_association" "adiryx_soc_platform" {
  management_group_id = azurerm_management_group.nonprod.id
  subscription_id     = local.subscription_id
}
