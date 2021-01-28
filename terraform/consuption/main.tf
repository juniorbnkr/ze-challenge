terraform {
  required_version = ">= 0.12"
}

provider "aws" {
  region = "${var.region}"
  profile = "default"
}

#---------------------------------------------------
#Enviroment configuration for AWS account
#---------------------------------------------------
resource "aws_vpc" "main" {
    cidr_block = "10.0.0.0/16" #change to enviroment configuration
    enable_dns_hostnames = true
}
resource "aws_route_table" "external" {
    vpc_id = "${aws_vpc.main.id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.main.id}"
    }
}
resource "aws_route_table_association" "external-main" {
    subnet_id = "subnet-id"
    route_table_id = "${aws_route_table.external.id}"
}
resource "aws_internet_gateway" "main" {
    vpc_id = "${aws_vpc.main.id}"
}
resource "aws_security_group" "load_balancers" {
    name = "load_balancers"
    description = "Allows traffic"
    vpc_id = "${aws_vpc.main.id}"

    ingress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
}


#---------------------------------------------------
# Sagemaker
#---------------------------------------------------
resource "aws_sagemaker_notebook_instance" "ni" {
  name                    = "data-science-notebook"
  role_arn                = "arn:aws:iam::000000000000:role/sudip_terraform_sagemaker_role"
  instance_type           = "ml.t2.medium"
  default_code_repository = "file-for-repository.zip"

  tags = {
    Name = "data-science-notebook"
  }
}


#---------------------------------------------------
# EKS for app provider
#---------------------------------------------------
resource "aws_eks_cluster" "eks_cluster" {
  name     = var.k8s_cluster_name
  role_arn                = "arn:aws:iam::000000000000:role/edit-this"
  version  = var.k8s_version
  vpc_config {
      subnet_ids = [
          var.private_subnet_1a,
          var.private_subnet_1b
      ]
  }

}
