resource "aws_cloudwatch_log_group" "rigor_agent" {
  name              = "/ecs/rigor-agent"
  retention_in_days = 30
}

resource "aws_cloudwatch_log_group" "watchtower" {
  count = var.watchtower_enabled ? 1 : 0

  name              = "/ecs/watchtower"
  retention_in_days = 3
}
