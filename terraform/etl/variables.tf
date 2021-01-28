variable "region" {
  type        = "string"
  description = "Região no AWS onde nossos recursos estarão."
  default     = "us-east-1"
}

#---------------------------------------------------
# Panoptes
#---------------------------------------------------
variable "instance_type_panoptes" {
  type        = "string"
  description = "Tipo de instância a ser utilizado"
  default     = "t2.micro"
}
variable "ami_panoptes" {
  type        = "string"
  description = "Id da imagem EC2 que desejamos utilizar para a instância."
  default     = "ami-0a313d6098716f372"
}

#---------------------------------------------------
# Amundsen
#---------------------------------------------------
variable "instance_type_amundsen" {
  type        = "string"
  description = "Tipo de instância a ser utilizado"
  default     = "t2.micro"
}
variable "ami_amundsen" {
  type        = "string"
  description = "Id da imagem EC2 que desejamos utilizar para a instância."
  default     = "ami-0a313d6098716f372"
}

#---------------------------------------------------
# Lambda File
#---------------------------------------------------
variable "lambda_function_payload" {
  description = "File for lambda payload."
  default     = "lambda_function_payload.zip"
}

#---------------------------------------------------
# Redshift
#---------------------------------------------------
variable "parameter_group_name" {
  description = "group name for redshift"
  default = "etl"
}
variable "redshift_subnet_group_name" {
  description = "subnet group name for redshift"
  default = "etl"
}
variable "cluster_master_username" {
  description = "username for redshift"
  default = "etlmaster"
}
variable "cluster_master_password" {
  description = "passwd for redshift"
  default = "Edit-this-pa55"
}
variable "cluster_database_name" {
  description = "database name for redshift"
  default = "master_database"
}
variable "cluster_number_of_nodes" {
  description = "number of nodes for redshift"
  default = 1
}
variable "cluster_node_type" {
  description = "Node Type of Redshift cluster"
  default     = "dc2.8xlarge"
  type = string
}
variable "cluster_version" {
  description = "Version of Redshift engine cluster"
  type        = string
  default     = "1.0"
}
variable "cluster_identifier" {
  description = "Instance name for redshift"
  type        = string
  default     = "data-warehouse"
}

#---------------------------------------------------
# AWS Glue job
#---------------------------------------------------
variable "glue_job_command_python_version" {
  description = "python_version"
  default     = null
}
variable "glue_job_command_name" {
  description = " The name of the job command. Defaults to glueetl."
  default     = null
}
variable "glue_job_command_script_location" {
  description = "(Required) Specifies the S3 path to a script that executes a job."
  default     = "edit-with-s3-script-path"
}
variable "glue_job_number_of_workers" {
  description = " The number of workers of a defined workerType that are allocated when a job runs."
  default     = 2
}
variable "glue_job_timeout" {
  description = " The job timeout in minutes. The default is 2880 minutes (48 hours)."
  default     = 12
}
variable "glue_job_name" {
  description = "job name"
  default     = "etl_job"
}
variable "glue_job_description" {
  description = "job description"
  default     = "ETLs for Batch Layer"
}

#---------------------------------------------------
# AWS Glue Catalog
#---------------------------------------------------
variable "glue_catalog_database_name" {
  description   = "The name of the database."
  default       = "data-lake"
}
variable "glue_catalog_database_description" {
  description   = " Description of the database."
  default       = "catalog form s3 lake"
}

#---------------------------------------------------
# AWS Glue Crawler
#---------------------------------------------------
variable "glue_crawler_role" {
  description   = "(Required) The IAM role friendly name (including path without leading slash), or ARN of an IAM role, used by the crawler to access other resources."
  default       = "edit-this"
}
variable "glue_crawler_name" {
  description   = "Name of the crawler."
  default       = "glue-crawler"
}
variable "glue_crawler_database_name" {
  description   = "Glue database where results are written."
  default       = "data-lake"
}
variable "glue_crawler_description" {
  description   = " Description of the crawler."
  default       = "Crawler for ETL layer"
}
variable "glue_crawler_jdbc_target" {
  description   = " List of nested JBDC target arguments. "
  default = [
  { connection_name = "s3_target", path = "data-lake", exclusions = [] },
]

}
