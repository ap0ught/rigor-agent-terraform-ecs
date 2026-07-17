variable "cluster_name" {
  description = "ECS cluster name."
  type        = string
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
  description = "Subnet used by the ECS hosts."
  type        = string
}

variable "security_group_id" {
  description = "Security group attached to the ECS hosts."
  type        = string
}

variable "rigor_agent_key" {
  description = "Rigor runner token consumed by the agent container."
  type        = string
  sensitive   = true
}

variable "watchtower_enabled" {
  description = "Whether to deploy the Watchtower daemon service."
  type        = bool
  default     = true
}
