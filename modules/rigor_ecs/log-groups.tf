resource "aws_cloudwatch_log_group" "rigor_agent" {
  name              = "/ecs/rigor-agent"
  retention_in_days = 30
}

resource "aws_cloudwatch_log_group" "watchtower" {
  name              = "/ecs/watchtower"
  retention_in_days = 3
}
