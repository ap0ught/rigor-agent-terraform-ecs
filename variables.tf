variable "region" {
  description = "AWS region where the ECS cluster will be deployed."
  type        = string
}

variable "ecs_cluster_name" {
  description = "Name of the ECS cluster and associated resources."
  type        = string
  default     = "rigor_private_location"
}

variable "asg_instance_types" {
  description = "Instance types used by the Spot Auto Scaling Group."
  type        = list(string)
  default     = ["m5.large"]
}

variable "cities" {
  description = "List of cities to size the ECS host fleet for."
  type        = list(string)

  validation {
    condition     = length(var.cities) > 0
    error_message = "Provide at least one city."
  }
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
