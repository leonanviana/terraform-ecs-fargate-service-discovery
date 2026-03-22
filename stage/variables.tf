variable "region" {
  type        = string
  description = "AWS region"
  default     = "us-east-1"
}

variable "tags" {
  type        = map(string)
  description = "A map of tags to assign to resources."
  default     = {}
}

variable "availability_zone" {
  type    = string
  default = "us-east-1b"
}

####### GENERAL #######

variable "app_count" {
  description = "Number of docker containers to run"
  default     = 1
}

variable "app_image" {
  type        = string
  description = "ECR image URI for the main application"
  default     = "<YOUR_AWS_ACCOUNT_ID>.dkr.ecr.us-east-1.amazonaws.com/myapp"
}

variable "app_port_app" {
  default = 80
}

variable "execution_role_arn" {
  type        = string
  description = "IAM role ARN for ECS task execution"
  default     = "arn:aws:iam::<YOUR_AWS_ACCOUNT_ID>:role/ecsTaskExecutionRole"
}

variable "fargate_cpu" {
  description = "Fargate instance CPU units (1 vCPU = 1024)"
  default     = "1024"
}

variable "fargate_memory" {
  description = "Fargate instance memory (MiB)"
  default     = "2048"
}

