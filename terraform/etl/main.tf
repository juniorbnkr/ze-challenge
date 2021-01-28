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
#  Lambdas for Glue trigger
#---------------------------------------------------
resource "aws_lambda_function" "test_lambda" {
  filename      = "${var.lambda_function_payload}"
  function_name = "lambda_for _glue_trigger"
  role          = "role_of aws_account"
  handler       = "exports.test"

  source_code_hash = filebase64sha256("lambda_function_payload.zip")

  runtime = "python3.8"
}
#[... more functions can be added here]


#---------------------------------------------------
#  Glue catalog database
#---------------------------------------------------
resource "aws_glue_catalog_database" "glue_catalog_database" {

    name            = var.glue_catalog_database_name
    description     = var.glue_catalog_database_description
    lifecycle {
        create_before_destroy   = true
        ignore_changes          = []
    }
}

#---------------------------------------------------
#  Glue crawler
#---------------------------------------------------
resource "aws_glue_crawler" "glue_crawler" {
    name                    = var.glue_crawler_name
    database_name           = var.glue_crawler_database_name
    role                    = var.glue_crawler_role
    description             = var.glue_crawler_description
    dynamic "jdbc_target" {
      iterator = jdbc_target
      for_each = var.glue_crawler_jdbc_target
      content {
          connection_name = lookup(jdbc_target.value, "connection_name", null)
          path            = lookup(jdbc_target.value, "path", null)
          exclusions      = lookup(jdbc_target.value, "exclusions", null)
      }
  }
    lifecycle {
        create_before_destroy   = true
        ignore_changes          = []
    }

    depends_on              = [
        aws_glue_catalog_database.glue_catalog_database,
    ]
}

#---------------------------------------------------
# AWS Glue job
#---------------------------------------------------
resource "aws_glue_job" "glue_job" {
    name                    = var.glue_job_name
    description             = var.glue_job_description
    role_arn                = "${aws_s3_bucket.lake.arn}"
    timeout                 = var.glue_job_timeout
    number_of_workers       = var.glue_job_number_of_workers

    command {
        script_location     = var.glue_job_command_script_location

        name                = var.glue_job_command_name
        python_version      = var.glue_job_command_python_version
    }

    lifecycle {
        create_before_destroy   = true
        ignore_changes          = []
    }
}

#---------------------------------------------------
#  EC2 for amundsen_app
#---------------------------------------------------

resource "aws_instance" "amundsen" {
  ami = "${var.ami_amundsen}"
  instance_type = "${var.instance_type_amundsen}"

  tags = {
    Name = "amundsen"
  }
}

#---------------------------------------------------
#  EC2 for panoptes_app
#---------------------------------------------------

resource "aws_instance" "panoptes" {
  ami = "${var.ami_panoptes}"
  instance_type = "${var.instance_type_panoptes}"
  tags = {
    Name = "panoptes"
  }
}

#---------------------------------------------------
#  SNS For notifications
#---------------------------------------------------
module "sns_topic" {
  source  = "terraform-aws-modules/sns/aws"
  version = "~> 2.0"

  name  = "my-topic"
}

#---------------------------------------------------
#  CloudWatch For Monitoring
#---------------------------------------------------

resource "aws_cloudwatch_dashboard" "dw_dashboard" {
  dashboard_name = "data-warehouse-monitoring"

  dashboard_body = "" #dash code here
}


#---------------------------------------------------
#  Redshift For Warehousing V2
#---------------------------------------------------

resource "aws_redshift_cluster" "this" {
  cluster_identifier = var.cluster_identifier
  cluster_version    = var.cluster_version
  node_type          = var.cluster_node_type
  number_of_nodes    = var.cluster_number_of_nodes
  cluster_type       = var.cluster_number_of_nodes > 1 ? "multi-node" : "single-node"
  database_name      = var.cluster_database_name
  master_username    = var.cluster_master_username
  master_password    = var.cluster_master_password

  port = 5439

  cluster_subnet_group_name    = var.redshift_subnet_group_name
  cluster_parameter_group_name = var.parameter_group_name
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
