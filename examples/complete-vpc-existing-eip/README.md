# Complete VPC

Configuration in this directory creates set of VPC resources which may be sufficient for staging or production environment.

This exemple shows how to use an existing EIP (public IP address). You will have to provide the ID of the existing EIP. Thus this EIP will be attached to the NAT Gateway and will be the SNAT rule public IP address.

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
| subnet\_ids | List of IDs of the created subnets with snat rule |
| vpc\_id | The Public IP adress of the SNAT rule |
