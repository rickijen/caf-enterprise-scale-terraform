# Declare a standard provider block using your preferred configuration.
# This will target the "default" Subscription and be used for the deployment of all "Core resources".
provider "azurerm" {
  features {}
}

# Declare an aliased provider block using your preferred configuration.
# This will be used for the deployment of all "Connectivity resources" to the specified `subscription_id`.
provider "azurerm" {
  alias           = "connectivity"
  #subscription_id = var.subscription_id_connectivity
  features {}
}

# Declare a standard provider block using your preferred configuration.
# This will be used for the deployment of all "Management resources" to the specified `subscription_id`.
provider "azurerm" {
  alias           = "management"
  #subscription_id = var.subscription_id_management
  features {}
}

# Obtain client configuration from the un-aliased provider
data "azurerm_client_config" "core" {
  provider = azurerm
}

# Obtain client configuration from the "management" provider
data "azurerm_client_config" "management" {
  provider = azurerm.management
}

# Obtain client configuration from the "connectivity" provider
data "azurerm_client_config" "connectivity" {
  provider = azurerm.connectivity
}

# Declare the Terraform Module for Cloud Adoption Framework
# Enterprise-scale and provide a base configuration.

module "enterprise_scale" {
  source  = "Azure/caf-enterprise-scale/azurerm"
  version = "1.1.2"

  providers = {
    azurerm              = azurerm
    azurerm.connectivity = azurerm.connectivity
    azurerm.management   = azurerm.management
  }

  root_parent_id = data.azurerm_client_config.core.tenant_id
  root_id        = var.root_id
  root_name      = var.root_name

  # Management
  deploy_management_resources    = var.deploy_management_resources
  subscription_id_management     = data.azurerm_client_config.core.subscription_id
  configure_management_resources = local.configure_management_resources

  # Identity
  deploy_identity_resources    = var.deploy_identity_resources
  subscription_id_identity     = data.azurerm_client_config.core.subscription_id
  configure_identity_resources = local.configure_identity_resources

  # Connectivity
  deploy_connectivity_resources    = var.deploy_connectivity_resources
  subscription_id_connectivity     = data.azurerm_client_config.core.subscription_id
  configure_connectivity_resources = local.configure_connectivity_resources

  # Demo Landing Zones
  # deploy_demo_landing_zones = true
  
  # Custom Landing Zones
  library_path   = "${path.root}/lib"
  custom_landing_zones = {
    "${var.root_id}-web-prod" = {
      display_name               = "${upper(var.root_id)} Web Apps Prod"
      parent_management_group_id = "${var.root_id}-landing-zones"
      subscription_ids           = [data.azurerm_client_config.core.subscription_id,]
      archetype_config = {
        archetype_id   = "customer_online"
        parameters     = {}
        access_control = {}
      }
    }
    "${var.root_id}-web-dev" = {
      display_name               = "${upper(var.root_id)} Web Apps Dev"
      parent_management_group_id = "${var.root_id}-landing-zones"
      subscription_ids           = [data.azurerm_client_config.core.subscription_id,]
      archetype_config = {
        archetype_id   = "customer_online"
        parameters     = {
          Deny-Resource-Locations = {
            listOfAllowedLocations = ["northeurope",]
          }
          Deny-RSG-Locations = {
            listOfAllowedLocations = ["northeurope",]
          }
        }
        access_control = {}
      }
    }
  }

  #
  # Archetype overrides
  #
  archetype_config_overrides = {}

  es_subscription_ids_map = {
    #------------------------------------------------------#
    # This variable is used to associate Azure subscription_ids
    # with the built-in Enterprise-scale Management Groups.
    # Simply add one or more Subscription IDs to any of the
    # built-in Management Groups listed below as required.
    #------------------------------------------------------#
    root           = []
    decommissioned = []
    sandboxes      = []
    landing-zones  = []
    platform       = []
    connectivity   = []
    management     = []
    identity       = []
    demo-corp      = []
    demo-online    = []
    demo-sap       = []
    #------------------------------------------------------#
    # EXAMPLES
    #------------------------------------------------------#
    # connectivity = [
    #   "3117d098-8b43-433b-849d-b761742eb717",
    # ]
    # management = [
    #   "9ee716a9-e411-433a-86ea-d82bf7b7ca61",
    # ]
    # identity = [
    #   "cae4c823-f353-4a34-a91a-acc5a0bd65c7",
    # ]
    #------------------------------------------------------#
  }

}
