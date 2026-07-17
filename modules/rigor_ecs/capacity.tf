locals {
  host_tags = {
    Name      = "${var.cluster_name}-Host"
    Cluster   = var.cluster_name
    ManagedBy = "Terraform"
  }
}

resource "aws_launch_template" "ecs_hosts" {
  name_prefix            = "${var.cluster_name}-hosts-"
  image_id               = data.aws_ami.ecs_optimized.id
  update_default_version = true

  iam_instance_profile {
    name = aws_iam_instance_profile.ecs_instance.name
  }

  vpc_security_group_ids = [var.security_group_id]

  user_data = base64encode(<<-EOT
    #!/bin/bash
    echo ECS_CLUSTER=${var.cluster_name} >> /etc/ecs/ecs.config
    echo ECS_ENABLE_SPOT_INSTANCE_DRAINING=true >> /etc/ecs/ecs.config
  EOT
  )

  block_device_mappings {
    device_name = data.aws_ami.ecs_optimized.root_device_name

    ebs {
      volume_size           = 30
      volume_type           = "gp3"
      encrypted             = true
      delete_on_termination = true
    }
  }

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
    tags          = local.host_tags
  }

  tag_specifications {
    resource_type = "volume"
    tags          = local.host_tags
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
  capacity_rebalance  = true

  mixed_instances_policy {
    instances_distribution {
      on_demand_base_capacity                  = 0
      on_demand_percentage_above_base_capacity = 0
      spot_allocation_strategy                 = "capacity-optimized"
    }

    launch_template {
      launch_template_specification {
        launch_template_id = aws_launch_template.ecs_hosts.id
        version            = aws_launch_template.ecs_hosts.default_version
      }

      dynamic "override" {
        for_each = toset(var.asg_instance_types)

        content {
          instance_type = override.value
        }
      }
    }
  }

  instance_refresh {
    strategy = "Rolling"

    preferences {
      min_healthy_percentage = 100
      instance_warmup        = 300
    }
  }

  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    value               = "${var.cluster_name}-Host"
    propagate_at_launch = true
  }

  tag {
    key                 = "Cluster"
    value               = var.cluster_name
    propagate_at_launch = true
  }

  tag {
    key                 = "ManagedBy"
    value               = "Terraform"
    propagate_at_launch = true
  }
}
