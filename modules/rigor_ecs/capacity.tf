resource "aws_launch_template" "ecs_hosts" {
  name_prefix   = "${var.cluster_name}-hosts-"
  image_id      = data.aws_ami.ecs_optimized.id
  instance_type = "m5.large"

  iam_instance_profile {
    name = aws_iam_instance_profile.ecs_instance.name
  }

  vpc_security_group_ids = [var.security_group_id]

  user_data = base64encode(<<-EOT
    #!/bin/bash
    echo ECS_CLUSTER=${var.cluster_name} >> /etc/ecs/ecs.config
  EOT
  )

  instance_market_options {
    market_type = "spot"
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 2
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.cluster_name}-Host"
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "ecs_hosts" {
  name                = "${var.cluster_name} Docker Hosts - ${aws_launch_template.ecs_hosts.name}"
  max_size            = var.asg_max_instance_count
  min_size            = var.asg_min_instance_count
  desired_capacity    = var.asg_desired_instance_count
  vpc_zone_identifier = [var.subnet_id]

  launch_template {
    id      = aws_launch_template.ecs_hosts.id
    version = "$Latest"
  }

  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    value               = "${var.cluster_name}-Host"
    propagate_at_launch = true
  }
}
