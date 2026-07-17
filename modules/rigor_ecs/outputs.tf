output "ecs_cluster_name" {
  value = aws_ecs_cluster.this.name
}

output "autoscaling_group_name" {
  value = aws_autoscaling_group.ecs_hosts.name
}

output "rigor_agent_service_name" {
  value = aws_ecs_service.rigor_agent.name
}
