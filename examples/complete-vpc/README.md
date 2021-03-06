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

## Outputs

| Name | Description |
|------|-------------|
| gateway\_id | ID of NAT gateway |
| snat\_eip | The Public IP adress of the SNAT rule |
| subnet\_ids | List of IDs of the created subnets with snat rule |
| vpc\_id | The Public IP adress of the SNAT rule |
