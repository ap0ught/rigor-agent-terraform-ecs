# rigor-agent-terraform-ecs

Reference Terraform for launching a Rigor agent on AWS ECS.

This refactor keeps the original deployment model but organizes it into a root module plus a reusable `modules/rigor_ecs` module.

## What it creates

- ECS cluster
- ECS service for the Rigor agent
- ECS daemon service for Watchtower
- Auto Scaling Group and launch template for ECS container instances
- IAM roles and instance profile for ECS hosts
- CloudWatch log groups for the two ECS services

## Layout

- `main.tf`, `variables.tf`, `versions.tf`: root module and provider wiring
- `modules/rigor_ecs/`: actual infrastructure implementation
- `terraform.tfvars`: example values to copy and fill in

## Before applying

You need:

- AWS credentials configured for the account you want to deploy into
- A VPC subnet ID
- A security group ID for the ECS hosts
- A Rigor runner token

Important: `rigor_agent_key` is sensitive and should not be committed with a real value. Prefer passing it via environment variable or a private tfvars file.

## Run

```sh
terraform init
terraform plan
terraform apply
```

## Notes from the audit

### Correctness and modernization

- The old layout mixed provider/config, IAM, ECS services, and ASG logic at the repo root.
- This refactor adds a proper module boundary and explicit variable types.
- The ASG now uses a launch template instead of the older launch configuration resource.
- The Rigor agent container is labeled for Watchtower updates, which the original config forgot to do.

### Security / AWS setup issues to review

- The Rigor token was previously injected as a plain environment variable. It is still sensitive here, but should ideally move to AWS Secrets Manager or SSM Parameter Store.
- Watchtower requires access to the Docker socket, which effectively gives it host-level control. That is a real security tradeoff.
- The original repo used a `local-exec sleep` on the instance profile, which is unreliable and removed here.
- No SSH key is attached to the instances, so debugging is intentionally remote-first.

### Suggested follow-up hardening

- Move the agent token to Secrets Manager.
- Add CloudWatch alarms for instance termination / ASG health.
- Consider a capacity provider strategy if you want ECS-managed scaling later.
