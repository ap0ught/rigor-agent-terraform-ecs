resource "aws_ecs_service" "rigor_agent" {
  name            = "rigor-agent"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.rigor_agent.arn
  desired_count   = 1

  capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.ecs_hosts.name
    weight            = 1
    base              = 1
  }
}

resource "aws_ecs_service" "watchtower" {
  name                = "watchtower"
  cluster             = aws_ecs_cluster.this.id
  task_definition     = aws_ecs_task_definition.watchtower.arn
  scheduling_strategy = "DAEMON"
  launch_type         = "EC2"
}
