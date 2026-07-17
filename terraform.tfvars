ecs_cluster_name = "rigor_private_location"
region           = "us-east-1"
# Set the city list in your shell, for example:
# export TF_VAR_cities='["New York","Los Angeles","Chicago","Houston","Phoenix","Philadelphia","San Antonio","San Diego","Dallas","San Jose"]'
# or place it in a private tfvars file that is not committed.
asg_instance_types = ["m5.large"]
subnet_id          = ""
rigor_agent_key    = ""
security_group_id  = ""
watchtower_enabled = true
