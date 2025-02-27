terraform {
  backend "s3" {
    bucket         = "awsaibucket1"
    key            = "terraform/state.tfstate"
    region         = "us-east-1"
    encrypt        = true
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "mlops_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "mlops-vpc"
  }
}

# Public Subnets in different AZs
resource "aws_subnet" "public_subnet_1" {
  vpc_id                  = aws_vpc.mlops_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "mlops-public-1"
    "kubernetes.io/cluster/mlops-eks" = "shared"
  }
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id                  = aws_vpc.mlops_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "mlops-public-2"
    "kubernetes.io/cluster/mlops-eks" = "shared"
  }
}

# Private Subnets in different AZs
resource "aws_subnet" "private_subnet_1" {
  vpc_id            = aws_vpc.mlops_vpc.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "mlops-private-1"
    "kubernetes.io/cluster/mlops-eks" = "shared"
  }
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id            = aws_vpc.mlops_vpc.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "mlops-private-2"
    "kubernetes.io/cluster/mlops-eks" = "shared"
  }
}

# Update EKS Cluster configuration
resource "aws_eks_cluster" "eks_cluster" {
  name     = "mlops-eks"
  role_arn = aws_iam_role.eks_role.arn

  vpc_config {
    subnet_ids = [
      aws_subnet.private_subnet_1.id,
      aws_subnet.private_subnet_2.id,
      aws_subnet.public_subnet_1.id,
      aws_subnet.public_subnet_2.id
    ]
    security_group_ids = [aws_security_group.eks_sg.id]
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy
  ]
}

# Add necessary IAM policy attachment
resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_role.name
}

# IAM Role for EKS Cluster
resource "aws_iam_role" "eks_role" {
  name = "eks-cluster-role-1"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name = "eks-cluster-role"
  }
}

# Security Group for EKS Cluster
resource "aws_security_group" "eks_sg" {
  name        = "eks-cluster-sg"
  description = "Security group for EKS cluster"
  vpc_id      = aws_vpc.mlops_vpc.id

  ingress {
    description = "Allow all inbound traffic within the security group"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "eks-cluster-sg"
  }
}

# Additional required policies for EKS Cluster

resource "aws_iam_role_policy_attachment" "eks_service_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.eks_role.name
}
