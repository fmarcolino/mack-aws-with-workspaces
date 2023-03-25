output "region_1_tls_private_key" {
  value     = module.system_on_region_1.tls_private_key
  sensitive = true
}

output "region_1_instance_ips" {
  value = module.system_on_region_1.instance_ips
}

output "region_1_database_url" {
  value = module.system_on_region_1.database_url
}

output "region_1_vpc_id" {
  value = module.system_on_region_1.vpc_id
}
