variable "cluster_name" {
  description = "ECS cluster name."
  type        = string
}

variable "asg_max_instance_count" {
  description = "Maximum number of ECS hosts."
  type        = number
}

variable "asg_min_instance_count" {
  description = "Minimum number of ECS hosts."
  type        = number
}

variable "asg_desired_instance_count" {
  description = "Desired number of ECS hosts."
  type        = number
}

variable "asg_instance_types" {
  description = "Instance types used by the Spot Auto Scaling Group."
  type        = list(string)
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
