terraform {
  required_version = ">= 0.12"
}

provider "aws" {
  region = "${var.region}"
  profile = "default"
}


#---------------------------------------------------
#  Enviroment configuration
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
#  ECS for Akka
#---------------------------------------------------
resource "aws_ecs_cluster" "ecs-akka" {
    name = "${var.akka_cluster_name}"
}

resource "aws_autoscaling_group" "akka-ecs-cluster" {
    name = "ECS ${var.akka_cluster_name}"
    min_size = "${var.akka_autoscale_min}"
    max_size = "${var.akka_autoscale_max}"
    desired_capacity = "${var.akka_autoscale_desired}"
    health_check_type = "EC2"
}


#---------------------------------------------------
#  ECS for spark
#---------------------------------------------------
resource "aws_ecs_cluster" "spark-ecs-spark" {
    name = "${var.spark_cluster_name}"
}

resource "aws_autoscaling_group" "ecs-cluster" {
    name = "ECS ${var.spark_cluster_name}"
    min_size = "${var.spark_autoscale_min}"
    max_size = "${var.spark_autoscale_max}"
    desired_capacity = "${var.spark_autoscale_desired}"
    health_check_type = "EC2"
}


#---------------------------------------------------
#Kinesis for Messaging
#---------------------------------------------------
resource "aws_kinesis_stream" "kinesis-ingestion" {

  name                      = var.hermes_name
  shard_count               = var.shard_count
  retention_period          = var.retention_period
  shard_level_metrics       = var.shard_level_metrics
  // Ignore future changes on the desired count value
  lifecycle {
    ignore_changes = [shard_count]
  }
}

#---------------------------------------------------
#S3 Bucket for data-lake
#---------------------------------------------------
resource "aws_s3_bucket" "lake" {
  bucket = "data-lake"
  acl    = "private"
  tags = {
    Name        = "lake"
    Environment = "Dev"
    Product = "data-lake"
  }
}
