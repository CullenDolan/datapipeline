variable "region" {
  default = "us-east-2"
}

variable "profile" {
  default = "default"
}

variable "db_password" {
  description = "RDS root user password"
  sensitive   = true
}