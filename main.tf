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
# ROOT
#################################################

resource "azurerm_management_group" "adiryx" {
  name         = "adiryx"
  display_name = "Adiryx"
}

#################################################
# LEVEL 1 UNDER ADIRYX
#################################################

resource "azurerm_management_group" "platform" {
  name                       = "adiryx-platform"
  display_name               = "Adiryx Platform"
  parent_management_group_id = azurerm_management_group.adiryx.id
}

resource "azurerm_management_group" "landingzones" {
  name                       = "adiryx-landingzones"
  display_name               = "Adiryx Landing Zones"
  parent_management_group_id = azurerm_management_group.adiryx.id
}

resource "azurerm_management_group" "sandbox" {
  name                       = "adiryx-sandbox"
  display_name               = "Adiryx Sandbox"
  parent_management_group_id = azurerm_management_group.adiryx.id
}

resource "azurerm_management_group" "decommissioned" {
  name                       = "adiryx-decommissioned"
  display_name               = "Adiryx Decommissioned"
  parent_management_group_id = azurerm_management_group.adiryx.id
}

#################################################
# PLATFORM CHILDREN
#################################################

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
# LANDING ZONE CHILDREN
#################################################

resource "azurerm_management_group" "corp" {
  name                       = "adiryx-corp"
  display_name               = "Adiryx Corp"
  parent_management_group_id = azurerm_management_group.landingzones.id
}

resource "azurerm_management_group" "online" {
  name                       = "adiryx-online"
  display_name               = "Adiryx Online"
  parent_management_group_id = azurerm_management_group.landingzones.id
}

#################################################
# CORP CHILDREN
#################################################

resource "azurerm_management_group" "production" {
  name                       = "adiryx-production"
  display_name               = "Adiryx Production"
  parent_management_group_id = azurerm_management_group.corp.id
}

resource "azurerm_management_group" "nonproduction" {
  name                       = "adiryx-non-production"
  display_name               = "Adiryx Non-Production"
  parent_management_group_id = azurerm_management_group.corp.id
}

#################################################
# SUBSCRIPTION PLACEMENT
#################################################

resource "azurerm_management_group_subscription_association" "adiryx_soc_platform" {
  management_group_id = azurerm_management_group.nonproduction.id
  subscription_id     = local.subscription_id
}

#################################################
# OUTPUT
#################################################

output "expected_management_group_structure" {
  value = {
    root              = "Tenant Root Group"
    adiryx            = azurerm_management_group.adiryx.display_name
    platform          = azurerm_management_group.platform.display_name
    identity          = azurerm_management_group.identity.display_name
    connectivity      = azurerm_management_group.connectivity.display_name
    management        = azurerm_management_group.management.display_name
    landing_zones     = azurerm_management_group.landingzones.display_name
    corp              = azurerm_management_group.corp.display_name
    production        = azurerm_management_group.production.display_name
    non_production    = azurerm_management_group.nonproduction.display_name
    online            = azurerm_management_group.online.display_name
    sandbox           = azurerm_management_group.sandbox.display_name
    decommissioned    = azurerm_management_group.decommissioned.display_name
    subscription_home = "Adiryx Non-Production"
  }
}
