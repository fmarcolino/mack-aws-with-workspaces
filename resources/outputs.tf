output "tls_private_key" {
  description = "Private key for instance access (all instances)"
  value     = tls_private_key.this.private_key_pem
  sensitive = true
}

output "instance_ips" {
  value = {
    web_instances = aws_instance.web_instances.*.public_ip
    backend_instances = aws_instance.backend_instances.*.private_ip
  }
}

output "database_url" {
  value = aws_db_instance.main.address
}

output "vpc_id" {
  value = aws_vpc.main.id
}
