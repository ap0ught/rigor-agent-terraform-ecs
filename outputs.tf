output "ecs_cluster_name" {
  value       = module.rigor_ecs.ecs_cluster_name
  description = "Created ECS cluster name."
}

output "ecs_autoscaling_group_name" {
  value       = module.rigor_ecs.autoscaling_group_name
  description = "Autoscaling group name for ECS hosts."
}

output "rigor_agent_service_name" {
  value       = module.rigor_ecs.rigor_agent_service_name
  description = "ECS service name for the Rigor agent."
}
