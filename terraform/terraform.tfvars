location            = "Australia East"
resource_group_name = "koalatech-week08-rg"

acr_name             = "koalatechacrw8s225095328"
storage_account_name = "koalatechstw8s225095328"

aks_cluster_name = "koalatech-aks"
aks_dns_prefix   = "koalatech"

aks_node_count   = 3
aks_node_vm_size = "Standard_B2s_v2"

kubernetes_version = "1.36.1"

environment = "development"

tags = {
    Project     = "KoalaTech Course Platform"
    ManagedBy   = "Terraform"
    Practical   = "Week08"
    Environment = "Development"
}
