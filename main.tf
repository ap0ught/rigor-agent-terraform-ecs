provider "aws" {
  region = var.region
}

module "rigor_ecs" {
  source = "./modules/rigor_ecs"

  cluster_name               = var.ecs_cluster_name
  asg_max_instance_count     = var.asg_max_instance_count
  asg_min_instance_count     = var.asg_min_instance_count
  asg_desired_instance_count = var.asg_desired_instance_count
  asg_instance_types         = var.asg_instance_types
  subnet_id                  = var.subnet_id
  security_group_id          = var.security_group_id
  rigor_agent_key            = var.rigor_agent_key
}
