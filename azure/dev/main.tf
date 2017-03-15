provider "azurerm" {
  tenant_id = "${var.az_tenant_id}"
  client_id = "${var.az_client_id}"
  client_secret = "${var.az_client_secret}"
  subscription_id = "${var.az_subscription_id}"
}

resource "azurerm_resource_group" "dev" {
  name     = "dev"
  location = "${var.location}"
}

resource "azurerm_container_service" "dev" {
  name                   = "asuna-dev"
  location               = "${azurerm_resource_group.dev.location}"
  resource_group_name    = "${azurerm_resource_group.dev.name}"
  orchestration_platform = "DCOS"

  master_profile {
    count      = "${var.master_count}"
    dns_prefix = "asuna-dev-master"
  }

  linux_profile {
    admin_username = "${var.admin_username}"
    ssh_key {
      key_data = "${file(var.public_key_file)}"
    }
  }

  agent_pool_profile {
    name       = "default"
    count      = "${var.agent_count}"
    dns_prefix = "asuna-dev-agent"
    vm_size    = "${var.agent_size}"
  }

  diagnostics_profile {
    enabled = false
  }

  tags {
    Environment = "Development"
  }
}
