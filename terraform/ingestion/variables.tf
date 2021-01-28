variable "region" {
  type        = "string"
  description = "Região no AWS onde nossos recursos estarão."
  default     = "us-east-1"
}

#---------------------------------------------------
# Batch Layer
#---------------------------------------------------
variable "ami_spark" {
  type        = "string"
  description = "Id da imagem EC2 que desejamos utilizar para a instância."
  default     = "ami-0a313d6098716f372"
}

variable "spark_cluster_name" {
    description = "The name of the Amazon ECS cluster."
    default = "spark"
}

variable "spark_autoscale_min" {
    default = "1"
    description = "Minimum spark_autoscale (number of EC2)"
}

variable "spark_autoscale_max" {
    default = "10"
    description = "Maximum spark_autoscale (number of EC2)"
}

variable "spark_autoscale_desired" {
    default = "4"
    description = "Desired akka_autoscale (number of EC2)"
}

#---------------------------------------------------
# Stream Layer
#---------------------------------------------------
variable "ami_akka" {
  type        = "string"
  description = "Id da imagem EC2 que desejamos utilizar para a instância."
  default     = "ami-0a313d6098716f372"
}

variable "akka_cluster_name" {
    description = "The name of the Amazon ECS cluster."
    default = "main"
}

variable "instance_type" {
  type        = "string"
  description = "Tipo de instância a ser utilizado"
  default     = "t2.micro"
}

  variable "akka_autoscale_min" {
      default = "1"
      description = "Minimum akka_autoscale (number of EC2)"
  }

  variable "akka_autoscale_max" {
      default = "10"
      description = "Maximum akka_autoscale (number of EC2)"
  }

  variable "akka_autoscale_desired" {
      default = "4"
      description = "Desired akka_autoscale (number of EC2)"
  }


variable "hermes_name" {
  description = "Nome do tópico Hermes. Será o mesmo nome do Bucket"
  default     = "terraform-kinesis"
}
variable "shard_count" {
  description = "The number of shards that the stream will use."
  default     = "1"
}

variable "retention_period" {
  description = "Length of time data records are accessible after they are added to the stream."
  default     = "48"
}

variable "shard_level_metrics" {
  type        = "list"
  description = "A list of shard-level CloudWatch metrics which can be enabled for the stream."
  default     = []
}
