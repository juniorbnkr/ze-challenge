variable "region" {
  type        = "string"
  description = "Região no AWS onde nossos recursos estarão."
  default     = "us-east-1"
}

variable "k8s_version" {
  type        = "string"
  default     = "1.0"
}

variable "k8s_cluster_name" {
  type        = "string"
  default     = "cluster-k8s"
}

variable "private_subnet_1a" {
  type        = "string"
  default     = "edit-this"
}

variable "private_subnet_1b" {
  type        = "string"
  default     = "edit-this"
}
