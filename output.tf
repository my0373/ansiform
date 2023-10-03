output "AWS_VPC_Region" {
  value = var.aws_region
}

output "private_subnet_vpc_range" {
    value = var.private_subnet_vpc_range
}

output "private_subnet_cidrs" {
  value = var.private_subnet_cidrs
}

output "public_subnet_cidrs" {
  value = var.public_subnet_cidrs
}

output "demo_tag" {
    value = var.demo_tag
}

output "eip_public" {
  value = aws_eip.public_eip
}

