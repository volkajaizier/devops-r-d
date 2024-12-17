Create 5 files main.tf outputs.tf provider.tf variables.tf terraform.tfvars

run command terraform init
run command terraform plan (adjust code due to errors)
run command terraform apply (adjust code due to errors)
run command terraform apply again


vladv@vvovk-lp:~/devops/devops-r-d/lecture-29$ terraform apply
var.bucket_name
  Base name for the S3 bucket

  Enter a value: yes

data.aws_availability_zone.available: Reading...
data.aws_availability_zone.available: Read complete after 0s [id=eu-west-3a]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # aws_eip.nat_eip will be created
  + resource "aws_eip" "nat_eip" {
      + allocation_id        = (known after apply)
      + arn                  = (known after apply)
      + association_id       = (known after apply)
      + carrier_ip           = (known after apply)
      + customer_owned_ip    = (known after apply)
      + domain               = "vpc"
      + id                   = (known after apply)
      + instance             = (known after apply)
      + ipam_pool_id         = (known after apply)
      + network_border_group = (known after apply)
      + network_interface    = (known after apply)
      + private_dns          = (known after apply)
      + private_ip           = (known after apply)
      + ptr_record           = (known after apply)
      + public_dns           = (known after apply)
      + public_ip            = (known after apply)
      + public_ipv4_pool     = (known after apply)
      + tags_all             = (known after apply)
      + vpc                  = (known after apply)
    }

  # aws_iam_instance_profile.ec2_instance-profile will be created
  + resource "aws_iam_instance_profile" "ec2_instance-profile" {
      + arn         = (known after apply)
      + create_date = (known after apply)
      + id          = (known after apply)
      + name        = "ec2_intance_profile"
      + name_prefix = (known after apply)
      + path        = "/"
      + role        = "ec2_s3_access_role"
      + tags_all    = (known after apply)
      + unique_id   = (known after apply)
    }

  # aws_iam_policy_attachment.s3_readonly will be created
  + resource "aws_iam_policy_attachment" "s3_readonly" {
      + id         = (known after apply)
      + name       = "s3_readonly_policy_attachment"
      + policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
      + roles      = [
          + "ec2_s3_access_role",
        ]
    }

  # aws_iam_role.ec2_role will be created
  + resource "aws_iam_role" "ec2_role" {
      + arn                   = (known after apply)
      + assume_role_policy    = jsonencode(
            {
              + Statement = [
                  + {
                      + Action    = "sts:AssumeRole"
                      + Effect    = "Allow"
                      + Principal = {
                          + Service = "ec2.amazonaws.com"
                        }
                    },
                ]
              + Version   = "2012-10-17"
            }
        )
      + create_date           = (known after apply)
      + force_detach_policies = false
      + id                    = (known after apply)
      + managed_policy_arns   = (known after apply)
      + max_session_duration  = 3600
      + name                  = "ec2_s3_access_role"
      + name_prefix           = (known after apply)
      + path                  = "/"
      + tags_all              = (known after apply)
      + unique_id             = (known after apply)

      + inline_policy (known after apply)
    }

  # aws_instance.public_instance will be created
  + resource "aws_instance" "public_instance" {
      + ami                                  = "ami-07dc1ccdcec3b4eab"
      + arn                                  = (known after apply)
      + associate_public_ip_address          = true
      + availability_zone                    = (known after apply)
      + cpu_core_count                       = (known after apply)
      + cpu_threads_per_core                 = (known after apply)
      + disable_api_stop                     = (known after apply)
      + disable_api_termination              = (known after apply)
      + ebs_optimized                        = (known after apply)
      + enable_primary_ipv6                  = (known after apply)
      + get_password_data                    = false
      + host_id                              = (known after apply)
      + host_resource_group_arn              = (known after apply)
      + iam_instance_profile                 = "ec2_intance_profile"
      + id                                   = (known after apply)
      + instance_initiated_shutdown_behavior = (known after apply)
      + instance_lifecycle                   = (known after apply)
      + instance_state                       = (known after apply)
      + instance_type                        = "t2.micro"
      + ipv6_address_count                   = (known after apply)
      + ipv6_addresses                       = (known after apply)
      + key_name                             = "devops"
      + monitoring                           = (known after apply)
      + outpost_arn                          = (known after apply)
      + password_data                        = (known after apply)
      + placement_group                      = (known after apply)
      + placement_partition_number           = (known after apply)
      + primary_network_interface_id         = (known after apply)
      + private_dns                          = (known after apply)
      + private_ip                           = (known after apply)
      + public_dns                           = (known after apply)
      + public_ip                            = (known after apply)
      + secondary_private_ips                = (known after apply)
      + security_groups                      = (known after apply)
      + source_dest_check                    = true
      + spot_instance_request_id             = (known after apply)
      + subnet_id                            = (known after apply)
      + tags_all                             = (known after apply)
      + tenancy                              = (known after apply)
      + user_data                            = (known after apply)
      + user_data_base64                     = (known after apply)
      + user_data_replace_on_change          = false
      + vpc_security_group_ids               = (known after apply)

      + capacity_reservation_specification (known after apply)

      + cpu_options (known after apply)

      + ebs_block_device (known after apply)

      + enclave_options (known after apply)

      + ephemeral_block_device (known after apply)

      + instance_market_options (known after apply)

      + maintenance_options (known after apply)

      + metadata_options (known after apply)

      + network_interface (known after apply)

      + private_dns_name_options (known after apply)

      + root_block_device (known after apply)
    }

  # aws_internet_gateway.igw will be created
  + resource "aws_internet_gateway" "igw" {
      + arn      = (known after apply)
      + id       = (known after apply)
      + owner_id = (known after apply)
      + tags_all = (known after apply)
      + vpc_id   = (known after apply)
    }

  # aws_nat_gateway.nat_gw will be created
  + resource "aws_nat_gateway" "nat_gw" {
      + allocation_id                      = (known after apply)
      + association_id                     = (known after apply)
      + connectivity_type                  = "public"
      + id                                 = (known after apply)
      + network_interface_id               = (known after apply)
      + private_ip                         = (known after apply)
      + public_ip                          = (known after apply)
      + secondary_private_ip_address_count = (known after apply)
      + secondary_private_ip_addresses     = (known after apply)
      + subnet_id                          = (known after apply)
      + tags_all                           = (known after apply)
    }

  # aws_route.public_rt will be created
  + resource "aws_route" "public_rt" {
      + destination_cidr_block = "0.0.0.0/0"
      + gateway_id             = (known after apply)
      + id                     = (known after apply)
      + instance_id            = (known after apply)
      + instance_owner_id      = (known after apply)
      + network_interface_id   = (known after apply)
      + origin                 = (known after apply)
      + route_table_id         = (known after apply)
      + state                  = (known after apply)
    }

  # aws_route_table.rt will be created
  + resource "aws_route_table" "rt" {
      + arn              = (known after apply)
      + id               = (known after apply)
      + owner_id         = (known after apply)
      + propagating_vgws = (known after apply)
      + route            = (known after apply)
      + tags_all         = (known after apply)
      + vpc_id           = (known after apply)
    }

  # aws_route_table_association.prt will be created
  + resource "aws_route_table_association" "prt" {
      + id             = (known after apply)
      + route_table_id = (known after apply)
      + subnet_id      = (known after apply)
    }

  # aws_s3_bucket.my_bucket will be created
  + resource "aws_s3_bucket" "my_bucket" {
      + acceleration_status         = (known after apply)
      + acl                         = (known after apply)
      + arn                         = (known after apply)
      + bucket                      = (known after apply)
      + bucket_domain_name          = (known after apply)
      + bucket_prefix               = (known after apply)
      + bucket_regional_domain_name = (known after apply)
      + force_destroy               = false
      + hosted_zone_id              = (known after apply)
      + id                          = (known after apply)
      + object_lock_enabled         = (known after apply)
      + policy                      = (known after apply)
      + region                      = (known after apply)
      + request_payer               = (known after apply)
      + tags                        = {
          + "Name" = "MyBucket"
        }
      + tags_all                    = {
          + "Name" = "MyBucket"
        }
      + website_domain              = (known after apply)
      + website_endpoint            = (known after apply)

      + cors_rule (known after apply)

      + grant (known after apply)

      + lifecycle_rule (known after apply)

      + logging (known after apply)

      + object_lock_configuration (known after apply)

      + replication_configuration (known after apply)

      + server_side_encryption_configuration (known after apply)

      + versioning (known after apply)

      + website (known after apply)
    }

  # aws_s3_bucket_acl.my_bucket_acl will be created
  + resource "aws_s3_bucket_acl" "my_bucket_acl" {
      + acl    = "private"
      + bucket = (known after apply)
      + id     = (known after apply)

      + access_control_policy (known after apply)
    }

  # aws_s3_bucket_versioning.my_bucket_versioning will be created
  + resource "aws_s3_bucket_versioning" "my_bucket_versioning" {
      + bucket = (known after apply)
      + id     = (known after apply)

      + versioning_configuration {
          + mfa_delete = (known after apply)
          + status     = "Enabled"
        }
    }

  # aws_security_group.my_sg will be created
  + resource "aws_security_group" "my_sg" {
      + arn                    = (known after apply)
      + description            = "Allow SSH, HTTPS"
      + egress                 = [
          + {
              + cidr_blocks      = [
                  + "0.0.0.0/0",
                ]
              + description      = "Allow all outbound traffic"
              + from_port        = 0
              + ipv6_cidr_blocks = []
              + prefix_list_ids  = []
              + protocol         = "-1"
              + security_groups  = []
              + self             = false
              + to_port          = 0
            },
        ]
      + id                     = (known after apply)
      + ingress                = [
          + {
              + cidr_blocks      = [
                  + "0.0.0.0/0",
                ]
              + description      = "HTTPS"
              + from_port        = 443
              + ipv6_cidr_blocks = []
              + prefix_list_ids  = []
              + protocol         = "tcp"
              + security_groups  = []
              + self             = false
              + to_port          = 443
            },
          + {
              + cidr_blocks      = [
                  + "0.0.0.0/0",
                ]
              + description      = "SSH"
              + from_port        = 22
              + ipv6_cidr_blocks = []
              + prefix_list_ids  = []
              + protocol         = "tcp"
              + security_groups  = []
              + self             = false
              + to_port          = 22
            },
        ]
      + name                   = (known after apply)
      + name_prefix            = (known after apply)
      + owner_id               = (known after apply)
      + revoke_rules_on_delete = false
      + tags_all               = (known after apply)
      + vpc_id                 = (known after apply)
    }

  # aws_subnet.public will be created
  + resource "aws_subnet" "public" {
      + arn                                            = (known after apply)
      + assign_ipv6_address_on_creation                = false
      + availability_zone                              = "eu-west-3a"
      + availability_zone_id                           = (known after apply)
      + cidr_block                                     = "10.0.1.0/24"
      + enable_dns64                                   = false
      + enable_resource_name_dns_a_record_on_launch    = false
      + enable_resource_name_dns_aaaa_record_on_launch = false
      + id                                             = (known after apply)
      + ipv6_cidr_block_association_id                 = (known after apply)
      + ipv6_native                                    = false
      + map_public_ip_on_launch                        = true
      + owner_id                                       = (known after apply)
      + private_dns_hostname_type_on_launch            = (known after apply)
      + tags_all                                       = (known after apply)
      + vpc_id                                         = (known after apply)
    }

  # aws_vpc.my_vpc will be created
  + resource "aws_vpc" "my_vpc" {
      + arn                                  = (known after apply)
      + cidr_block                           = "10.0.0.0/16"
      + default_network_acl_id               = (known after apply)
      + default_route_table_id               = (known after apply)
      + default_security_group_id            = (known after apply)
      + dhcp_options_id                      = (known after apply)
      + enable_dns_hostnames                 = (known after apply)
      + enable_dns_support                   = true
      + enable_network_address_usage_metrics = (known after apply)
      + id                                   = (known after apply)
      + instance_tenancy                     = "default"
      + ipv6_association_id                  = (known after apply)
      + ipv6_cidr_block                      = (known after apply)
      + ipv6_cidr_block_network_border_group = (known after apply)
      + main_route_table_id                  = (known after apply)
      + owner_id                             = (known after apply)
      + tags                                 = {
          + "Name" = "MyVPC"
        }
      + tags_all                             = {
          + "Name" = "MyVPC"
        }
    }

  # random_id.unique_id will be created
  + resource "random_id" "unique_id" {
      + b64_std     = (known after apply)
      + b64_url     = (known after apply)
      + byte_length = 4
      + dec         = (known after apply)
      + hex         = (known after apply)
      + id          = (known after apply)
    }

Plan: 17 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + bucket_arn    = (known after apply)
  + bucket_name   = (known after apply)
  + ec2_public_ip = {
      + address                   = null
      + allocation_id             = (known after apply)
      + arn                       = (known after apply)
      + associate_with_private_ip = null
      + association_id            = (known after apply)
      + carrier_ip                = (known after apply)
      + customer_owned_ip         = (known after apply)
      + customer_owned_ipv4_pool  = null
      + domain                    = "vpc"
      + id                        = (known after apply)
      + instance                  = (known after apply)
      + ipam_pool_id              = (known after apply)
      + network_border_group      = (known after apply)
      + network_interface         = (known after apply)
      + private_dns               = (known after apply)
      + private_ip                = (known after apply)
      + ptr_record                = (known after apply)
      + public_dns                = (known after apply)
      + public_ip                 = (known after apply)
      + public_ipv4_pool          = (known after apply)
      + tags                      = null
      + tags_all                  = (known after apply)
      + timeouts                  = null
      + vpc                       = (known after apply)
    }

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

random_id.unique_id: Creating...
random_id.unique_id: Creation complete after 0s [id=WJP9rQ]
aws_iam_role.ec2_role: Creating...
aws_eip.nat_eip: Creating...
aws_vpc.my_vpc: Creating...
aws_s3_bucket.my_bucket: Creating...
aws_eip.nat_eip: Creation complete after 1s [id=eipalloc-0e3c0d276c874b162]
aws_iam_role.ec2_role: Creation complete after 1s [id=ec2_s3_access_role]
aws_iam_policy_attachment.s3_readonly: Creating...
aws_iam_instance_profile.ec2_instance-profile: Creating...
aws_vpc.my_vpc: Creation complete after 2s [id=vpc-0b57701024c40133a]
aws_internet_gateway.igw: Creating...
aws_route_table.rt: Creating...
aws_subnet.public: Creating...
aws_security_group.my_sg: Creating...
aws_iam_policy_attachment.s3_readonly: Creation complete after 1s [id=s3_readonly_policy_attachment]
aws_internet_gateway.igw: Creation complete after 0s [id=igw-0d4011733c5194ceb]
aws_route_table.rt: Creation complete after 0s [id=rtb-05e5cfdf8c4940683]
aws_route.public_rt: Creating...
aws_s3_bucket.my_bucket: Creation complete after 2s [id=yes-5893fdad]
aws_s3_bucket_versioning.my_bucket_versioning: Creating...
aws_s3_bucket_acl.my_bucket_acl: Creating...
aws_route.public_rt: Creation complete after 1s [id=r-rtb-05e5cfdf8c49406831080289494]
aws_s3_bucket_versioning.my_bucket_versioning: Creation complete after 2s [id=yes-5893fdad]
aws_security_group.my_sg: Creation complete after 2s [id=sg-04004d8a7a1d2896e]
aws_iam_instance_profile.ec2_instance-profile: Creation complete after 7s [id=ec2_intance_profile]
aws_subnet.public: Still creating... [10s elapsed]
aws_subnet.public: Creation complete after 11s [id=subnet-00550f480ca667115]
aws_route_table_association.prt: Creating...
aws_nat_gateway.nat_gw: Creating...
aws_instance.public_instance: Creating...
aws_route_table_association.prt: Creation complete after 0s [id=rtbassoc-04773e57a114ebb3c]
aws_nat_gateway.nat_gw: Still creating... [10s elapsed]
aws_instance.public_instance: Still creating... [10s elapsed]
aws_instance.public_instance: Creation complete after 13s [id=i-070e12b8627dd0a16]
aws_nat_gateway.nat_gw: Still creating... [20s elapsed]
aws_nat_gateway.nat_gw: Still creating... [30s elapsed]
aws_nat_gateway.nat_gw: Still creating... [40s elapsed]
aws_nat_gateway.nat_gw: Still creating... [50s elapsed]
aws_nat_gateway.nat_gw: Still creating... [1m0s elapsed]
aws_nat_gateway.nat_gw: Still creating... [1m10s elapsed]
aws_nat_gateway.nat_gw: Still creating... [1m20s elapsed]
aws_nat_gateway.nat_gw: Still creating... [1m30s elapsed]
aws_nat_gateway.nat_gw: Still creating... [1m40s elapsed]
aws_nat_gateway.nat_gw: Still creating... [1m50s elapsed]
aws_nat_gateway.nat_gw: Still creating... [2m0s elapsed]
aws_nat_gateway.nat_gw: Still creating... [2m10s elapsed]
aws_nat_gateway.nat_gw: Creation complete after 2m15s [id=nat-09853ca1564f38fcd]
╷
│ Error: creating S3 Bucket (yes-5893fdad) ACL: operation error S3: PutBucketAcl, https response error StatusCode: 400, RequestID: Q1WFPBG0C15KG9RD, HostID: sUGx9xDWYXRLy15iISxr/WAOc+7sY+A4M6tgJKWzFwYCHSbVvzr89CAjMjSneHwfEXUOUDKkLWs=, api error AccessControlListNotSupported: The bucket does not allow ACLs
│ 
│   with aws_s3_bucket_acl.my_bucket_acl,
│   on main.tf line 145, in resource "aws_s3_bucket_acl" "my_bucket_acl":
│  145: resource "aws_s3_bucket_acl" "my_bucket_acl" {
│ 
╵
vladv@vvovk-lp:~/devops/devops-r-d/lecture-29$ terraform apply
var.bucket_name
  Base name for the S3 bucket

  Enter a value: yes

random_id.unique_id: Refreshing state... [id=WJP9rQ]
data.aws_availability_zone.available: Reading...
aws_iam_role.ec2_role: Refreshing state... [id=ec2_s3_access_role]
aws_eip.nat_eip: Refreshing state... [id=eipalloc-0e3c0d276c874b162]
aws_vpc.my_vpc: Refreshing state... [id=vpc-0b57701024c40133a]
aws_s3_bucket.my_bucket: Refreshing state... [id=yes-5893fdad]
data.aws_availability_zone.available: Read complete after 0s [id=eu-west-3a]
aws_iam_policy_attachment.s3_readonly: Refreshing state... [id=s3_readonly_policy_attachment]
aws_iam_instance_profile.ec2_instance-profile: Refreshing state... [id=ec2_intance_profile]
aws_s3_bucket_versioning.my_bucket_versioning: Refreshing state... [id=yes-5893fdad]
aws_route_table.rt: Refreshing state... [id=rtb-05e5cfdf8c4940683]
aws_internet_gateway.igw: Refreshing state... [id=igw-0d4011733c5194ceb]
aws_subnet.public: Refreshing state... [id=subnet-00550f480ca667115]
aws_security_group.my_sg: Refreshing state... [id=sg-04004d8a7a1d2896e]
aws_route.public_rt: Refreshing state... [id=r-rtb-05e5cfdf8c49406831080289494]
aws_route_table_association.prt: Refreshing state... [id=rtbassoc-04773e57a114ebb3c]
aws_nat_gateway.nat_gw: Refreshing state... [id=nat-09853ca1564f38fcd]
aws_instance.public_instance: Refreshing state... [id=i-070e12b8627dd0a16]

Note: Objects have changed outside of Terraform

Terraform detected the following changes made outside of Terraform since the last "terraform apply" which may have affected this plan:

  # aws_eip.nat_eip has changed
  ~ resource "aws_eip" "nat_eip" {
      + association_id           = "eipassoc-095d8c607832295bb"
        id                       = "eipalloc-0e3c0d276c874b162"
      + network_interface        = "eni-075a9d5c474a7a0a8"
      + private_dns              = "ip-10-0-1-214.eu-west-3.compute.internal"
      + private_ip               = "10.0.1.214"
      + tags                     = {}
        # (14 unchanged attributes hidden)
    }


Unless you have made equivalent changes to your configuration, or ignored the relevant attributes using ignore_changes, the following plan may include actions to undo or respond to these changes.

──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  ~ update in-place
-/+ destroy and then create replacement

Terraform will perform the following actions:

  # aws_iam_policy_attachment.s3_readonly will be updated in-place
  ~ resource "aws_iam_policy_attachment" "s3_readonly" {
        id         = "s3_readonly_policy_attachment"
        name       = "s3_readonly_policy_attachment"
      ~ users      = [
          - "vladv",
        ]
        # (3 unchanged attributes hidden)
    }

  # aws_instance.public_instance must be replaced
-/+ resource "aws_instance" "public_instance" {
      ~ arn                                  = "arn:aws:ec2:eu-west-3:817539924586:instance/i-070e12b8627dd0a16" -> (known after apply)
      ~ availability_zone                    = "eu-west-3a" -> (known after apply)
      ~ cpu_core_count                       = 1 -> (known after apply)
      ~ cpu_threads_per_core                 = 1 -> (known after apply)
      ~ disable_api_stop                     = false -> (known after apply)
      ~ disable_api_termination              = false -> (known after apply)
      ~ ebs_optimized                        = false -> (known after apply)
      + enable_primary_ipv6                  = (known after apply)
      - hibernation                          = false -> null
      + host_id                              = (known after apply)
      + host_resource_group_arn              = (known after apply)
      ~ id                                   = "i-070e12b8627dd0a16" -> (known after apply)
      ~ instance_initiated_shutdown_behavior = "stop" -> (known after apply)
      + instance_lifecycle                   = (known after apply)
      ~ instance_state                       = "running" -> (known after apply)
      ~ ipv6_address_count                   = 0 -> (known after apply)
      ~ ipv6_addresses                       = [] -> (known after apply)
      ~ monitoring                           = false -> (known after apply)
      + outpost_arn                          = (known after apply)
      + password_data                        = (known after apply)
      + placement_group                      = (known after apply)
      ~ placement_partition_number           = 0 -> (known after apply)
      ~ primary_network_interface_id         = "eni-0ceb1adccedf0e7f2" -> (known after apply)
      ~ private_dns                          = "ip-10-0-1-80.eu-west-3.compute.internal" -> (known after apply)
      ~ private_ip                           = "10.0.1.80" -> (known after apply)
      + public_dns                           = (known after apply)
      ~ public_ip                            = "13.37.239.59" -> (known after apply)
      ~ secondary_private_ips                = [] -> (known after apply)
      ~ security_groups                      = [ # forces replacement
          + "sg-04004d8a7a1d2896e",
        ]
      + spot_instance_request_id             = (known after apply)
      - tags                                 = {} -> null
      ~ tags_all                             = {} -> (known after apply)
      ~ tenancy                              = "default" -> (known after apply)
      + user_data                            = (known after apply)
      + user_data_base64                     = (known after apply)
      ~ vpc_security_group_ids               = [
          - "sg-04004d8a7a1d2896e",
        ] -> (known after apply)
        # (9 unchanged attributes hidden)

      ~ capacity_reservation_specification (known after apply)
      - capacity_reservation_specification {
          - capacity_reservation_preference = "open" -> null
        }

      ~ cpu_options (known after apply)
      - cpu_options {
          - core_count       = 1 -> null
          - threads_per_core = 1 -> null
            # (1 unchanged attribute hidden)
        }

      - credit_specification {
          - cpu_credits = "standard" -> null
        }

      ~ ebs_block_device (known after apply)

      ~ enclave_options (known after apply)
      - enclave_options {
          - enabled = false -> null
        }

      ~ ephemeral_block_device (known after apply)

      ~ instance_market_options (known after apply)

      ~ maintenance_options (known after apply)
      - maintenance_options {
          - auto_recovery = "default" -> null
        }

      ~ metadata_options (known after apply)
      - metadata_options {
          - http_endpoint               = "enabled" -> null
          - http_protocol_ipv6          = "disabled" -> null
          - http_put_response_hop_limit = 2 -> null
          - http_tokens                 = "required" -> null
          - instance_metadata_tags      = "disabled" -> null
        }

      ~ network_interface (known after apply)

      ~ private_dns_name_options (known after apply)
      - private_dns_name_options {
          - enable_resource_name_dns_a_record    = false -> null
          - enable_resource_name_dns_aaaa_record = false -> null
          - hostname_type                        = "ip-name" -> null
        }

      ~ root_block_device (known after apply)
      - root_block_device {
          - delete_on_termination = true -> null
          - device_name           = "/dev/xvda" -> null
          - encrypted             = false -> null
          - iops                  = 3000 -> null
          - tags                  = {} -> null
          - tags_all              = {} -> null
          - throughput            = 125 -> null
          - volume_id             = "vol-08c59c383e7ba54ba" -> null
          - volume_size           = 8 -> null
          - volume_type           = "gp3" -> null
            # (1 unchanged attribute hidden)
        }
    }

Plan: 1 to add, 1 to change, 1 to destroy.

Changes to Outputs:
  ~ ec2_public_ip = {
      ~ association_id            = "" -> "eipassoc-095d8c607832295bb"
        id                        = "eipalloc-0e3c0d276c874b162"
      ~ network_interface         = "" -> "eni-075a9d5c474a7a0a8"
      ~ private_dns               = null -> "ip-10-0-1-214.eu-west-3.compute.internal"
      ~ private_ip                = "" -> "10.0.1.214"
      ~ tags                      = null -> {}
        # (18 unchanged attributes hidden)
    }

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

aws_iam_policy_attachment.s3_readonly: Modifying... [id=s3_readonly_policy_attachment]
aws_instance.public_instance: Destroying... [id=i-070e12b8627dd0a16]
aws_iam_policy_attachment.s3_readonly: Modifications complete after 1s [id=s3_readonly_policy_attachment]
aws_instance.public_instance: Still destroying... [id=i-070e12b8627dd0a16, 10s elapsed]
aws_instance.public_instance: Still destroying... [id=i-070e12b8627dd0a16, 20s elapsed]
aws_instance.public_instance: Still destroying... [id=i-070e12b8627dd0a16, 30s elapsed]
aws_instance.public_instance: Still destroying... [id=i-070e12b8627dd0a16, 40s elapsed]
aws_instance.public_instance: Destruction complete after 41s
aws_instance.public_instance: Creating...
aws_instance.public_instance: Still creating... [10s elapsed]
aws_instance.public_instance: Creation complete after 13s [id=i-0caa0442fc3006d3c]

Apply complete! Resources: 1 added, 1 changed, 1 destroyed.

Outputs:

bucket_arn = "arn:aws:s3:::yes-5893fdad"
bucket_name = "yes-5893fdad"
ec2_public_ip = {
  "address" = tostring(null)
  "allocation_id" = "eipalloc-0e3c0d276c874b162"
  "arn" = "arn:aws:ec2:eu-west-3:817539924586:elastic-ip/eipalloc-0e3c0d276c874b162"
  "associate_with_private_ip" = tostring(null)
  "association_id" = "eipassoc-095d8c607832295bb"
  "carrier_ip" = ""
  "customer_owned_ip" = ""
  "customer_owned_ipv4_pool" = ""
  "domain" = "vpc"
  "id" = "eipalloc-0e3c0d276c874b162"
  "instance" = ""
  "ipam_pool_id" = tostring(null)
  "network_border_group" = "eu-west-3"
  "network_interface" = "eni-075a9d5c474a7a0a8"
  "private_dns" = "ip-10-0-1-214.eu-west-3.compute.internal"
  "private_ip" = "10.0.1.214"
  "ptr_record" = ""
  "public_dns" = "ec2-15-236-56-204.eu-west-3.compute.amazonaws.com"
  "public_ip" = "15.236.56.204"
  "public_ipv4_pool" = "amazon"
  "tags" = tomap({})
  "tags_all" = tomap({})
  "timeouts" = null /* object */
  "vpc" = true
}