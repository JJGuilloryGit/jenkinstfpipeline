# VPC
output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.mlops_vpc.id
}

# Subnets
output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]
}

output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value       = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id]
}

# EKS Cluster
output "eks_cluster_name" {
  description = "The name of the EKS cluster"
  value       = aws_eks_cluster.eks_cluster.name
}

output "eks_cluster_endpoint" {
  description = "The endpoint for the EKS cluster"
  value       = aws_eks_cluster.eks_cluster.endpoint
}

output "eks_cluster_certificate_authority" {
  description = "Certificate authority data for the EKS cluster"
  value       = aws_eks_cluster.eks_cluster.certificate_authority[0].data
}

# Security Groups
output "eks_security_group_id" {
  description = "Security group ID for the EKS cluster"
  value       = aws_security_group.eks_sg.id
}

# NAT Gateway
output "nat_gateway_ip" {
  description = "Public IP address of the NAT Gateway"
  value       = aws_eip.nat_eip.public_ip
}

# Route Tables
output "public_route_table_id" {
  description = "ID of the public route table"
  value       = aws_route_table.public.id
}

output "private_route_table_id" {
  description = "ID of the private route table"
  value       = aws_route_table.private.id
}

# IAM Role
output "eks_cluster_role_arn" {
  description = "ARN of the EKS cluster IAM role"
  value       = aws_iam_role.eks_role.arn
}

# Region Information
output "availability_zones" {
  description = "List of availability zones used in the VPC"
  value       = [aws_subnet.private_subnet_1.availability_zone, aws_subnet.private_subnet_2.availability_zone]
}
