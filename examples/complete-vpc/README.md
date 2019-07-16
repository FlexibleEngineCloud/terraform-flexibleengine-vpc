# Complete VPC

Configuration in this directory creates set of VPC resources which may be sufficient for staging or production environment.

## Usage

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example may create resources which can cost money (Elastic IP (EIP) and NAT Gateway, for example). Run `terraform destroy` when you don't need these resources.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Outputs

| Name | Description |
|------|-------------|
| gateway_id | ID of NAT gateway |
| subnet_ids | List of IDs of the created subnets with snat rule |
| vpc_id | ID of the created vpc |


<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
