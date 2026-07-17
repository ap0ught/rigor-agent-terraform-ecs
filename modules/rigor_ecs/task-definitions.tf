resource "aws_ecs_task_definition" "rigor_agent" {
  family                   = "rigor-agent"
  requires_compatibilities = ["EC2"]
  network_mode             = "bridge"
  cpu                      = 2048
  memory                   = 7000

  container_definitions = jsonencode([
    {
      name      = "rigor-agent"
      image     = "docker.rigor.com/agent:stable"
      essential = true
      cpu       = 2048
      memory    = 7000
      environment = [
        {
          name  = "RUNNER_TOKEN"
          value = var.rigor_agent_key
        }
      ]
      dockerLabels = {
        "com.centurylinklabs.watchtower.enable" = "true"
      }
      linuxParameters = {
        capabilities = {
          add = ["NET_ADMIN"]
        }
      }
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.rigor_agent.name
          awslogs-region        = data.aws_region.current.name
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}

resource "aws_ecs_task_definition" "watchtower" {
  count = var.watchtower_enabled ? 1 : 0

  family                   = "watchtower"
  requires_compatibilities = ["EC2"]
  network_mode             = "bridge"

  volume {
    name      = "docker-sock"
    host_path = "/var/run/docker.sock"
  }

  container_definitions = jsonencode([
    {
      name      = "watchtower"
      image     = "v2tec/watchtower"
      essential = true
      memory    = 32
      command   = ["--label-enable", "--cleanup"]
      mountPoints = [
        {
          sourceVolume  = "docker-sock"
          containerPath = "/var/run/docker.sock"
          readOnly      = false
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.watchtower[0].name
          awslogs-region        = data.aws_region.current.name
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}
