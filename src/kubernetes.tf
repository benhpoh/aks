module "azurerm_kubernetes_cluster_primary" {
  source                          = "github.com/bradmccoydev/terraform-modules//azurerm/azurerm_kubernetes_cluster"
  name                            = local.primary_name
  dns_prefix                      = "aks"
  location                        = var.cloud_location_1.name
  resource_group_name             = module.azurerm_resource_group.name
  private_cluster_enabled         = false
  kubernetes_network_plugin       = "azure"
  kubernetes_network_policy       = var.kubernetes_network_policy
  kubernetes_subnet_id            = module.azurerm_subnet_kubernetes.id
  node_count                      = var.kubernetes_initial_node_count
  node_size                       = var.kubernetes_node_size
  node_disk_size                  = var.kubernetes_node_disk_size
  enable_http_application_routing = false
  tags                            = merge(local.tags, var.cloud_custom_tags)
}

module "azurerm_kubernetes_cluster_node_pool_primary" {
  source                = "github.com/bradmccoydev/terraform-modules//azurerm/azurerm_kubernetes_cluster_node_pool"
  name                  = substr(replace(local.primary_name, "-", ""), 0, 12)
  kubernetes_cluster_id = module.azurerm_kubernetes_cluster_primary.id
  vm_size               = var.kubernetes_node_size
  min_count             = 2
  max_count             = 2
  kubernetes_subnet_id  = module.azurerm_subnet_kubernetes.id

  tags = merge(local.tags, var.cloud_custom_tags)
}
