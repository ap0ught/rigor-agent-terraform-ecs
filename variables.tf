variable "region" {
  description = "AWS region where the ECS cluster will be deployed."
  type        = string
}

variable "ecs_cluster_name" {
  description = "Name of the ECS cluster and associated resources."
  type        = string
  default     = "rigor_private_location"
}

variable "asg_max_instance_count" {
  description = "Maximum number of ECS container instances."
  type        = number
  default     = 1
}

variable "asg_min_instance_count" {
  description = "Minimum number of ECS container instances."
  type        = number
  default     = 1
}

variable "asg_desired_instance_count" {
  description = "Desired number of ECS container instances."
  type        = number
  default     = 1
}

variable "subnet_id" {
  description = "Subnet used by the ECS container instances."
  type        = string
}

variable "security_group_id" {
  description = "Security group attached to the ECS container instances."
  type        = string
}

variable "rigor_agent_key" {
  description = "Rigor runner token used by the agent container."
  type        = string
  sensitive   = true
}

variable "watchtower_enabled" {
  description = "Whether to deploy the Watchtower daemon service."
  type        = bool
  default     = true
}
