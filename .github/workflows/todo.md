# TODOs

## On PR to main

Job ("plan + validate")
- Log in to AWS (by env)
- run Terraform Plan 
- Checkov(?) etc
- attach plan output to PR

## On commit (main) or Tag (prefix)

Job (final plan)
- Log into AWS (by env)
- run terraform plan
- upload plan output to artifacts (env-commit-hash.tfplan), store 1 day

## Job ("apply") - Requires Approval

- Log into AWS (by env)
- download artifact (env-commit-hash.tfplan)
- terraform init --backend-config (env).config
- terraform apply --no-verify --var-file (env).tfvars
