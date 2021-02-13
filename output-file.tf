output "backend_public_ips" {
  value = aws_instance.backend[0].public_ip
}

output "backend_public_ip" {
  value = aws_instance.backend[1].public_ip
}


output "backend_public_dns" {
  value = aws_instance.backend.*.public_dns
}
