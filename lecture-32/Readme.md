Create a terragform file to create infrastructure to test our ansible

1. Create a "baseline" role for basic server settings
* Configure SSH keys
* Install basic packages (vim, git, mc, ufw)

Create role Baseline with 3 folders vars,tasks and files with main script in task folder main.yml file
Folder files contain public key
vars contain secrets.yml which is encrypted with ansible vault
command 
ansible-vault create secrets.yml


2. Create a role for configuring the firewall
* Configure basic firewall rules using ufw
Created role Firewall
with folder task and main.yml file in it


3. Create a role for configuring Nginx
* Install Nginx
* Configure the configuration file and deploy index.html using templates and variables
Created role Nginx
with folder task and templates and main.yml file in it

4. Use dynamic inventory to manage the infrastructure
* Configure dynamic inventory for AWS

file aws_ec2.yml created for dynamic inventory
also create file ansible.cfg with different configurations

5. Use Ansible Vault to encrypt sensitive data
* Encrypt sensitive data (e.g. passwords) using Ansible Vault

file secrets.yml were encrypted
6. Configure multiple playbooks for different situations from existing roles

playbook created for different roles all and ansible but in our case it is the same :)

Dynamic inventory works
vladv@vvovk-lp:~/devops/devops-r-d/lecture-32$ ansible-inventory -i aws_ec2.yml --list
[WARNING]: Collection amazon.aws does not support Ansible version 2.13.13
{
    "_meta": {
        "hostvars": {
            "ec2-15-237-255-62.eu-west-3.compute.amazonaws.com": {
                "ami_launch_index": 0,
                "ansible_host": "15.237.255.62",
                "architecture": "x86_64",
                "block_device_mappings": [
                    {
                        "device_name": "/dev/sda1",
                        "ebs": {
                            "attach_time": "2025-01-16T11:53:51+00:00",
                            "delete_on_termination": true,
                            "status": "attached",
                            "volume_id": "vol-0076c5240419e16e4"
                        }
                    }
                ],
                "boot_mode": "uefi-preferred",
                "capacity_reservation_specification": {
                    "capacity_reservation_preference": "open"
                },
                "client_token": "terraform-20250116115349348100000003",
                "cpu_options": {
                    "core_count": 1,
                    "threads_per_core": 1
                },
                "current_instance_boot_mode": "legacy-bios",
                "ebs_optimized": false,
                "ena_support": true,
                "enclave_options": {
                    "enabled": false
                },
                "hibernation_options": {
                    "configured": false
                },
                "hypervisor": "xen",
                "image_id": "ami-09be70e689bddcef5",
                "instance_id": "i-0d4620aa10ff910e2",
                "instance_type": "t2.micro",
                "key_name": "lecture32",
                "launch_time": "2025-01-16T11:53:50+00:00",
                "maintenance_options": {
                    "auto_recovery": "default"
                },
                "metadata_options": {
                    "http_endpoint": "enabled",
                    "http_protocol_ipv6": "disabled",
                    "http_put_response_hop_limit": 2,
                    "http_tokens": "required",
                    "instance_metadata_tags": "disabled",
                    "state": "applied"
                },
                "monitoring": {
                    "state": "disabled"
                },
                "network_interfaces": [
                    {
                        "association": {
                            "ip_owner_id": "amazon",
                            "public_dns_name": "ec2-15-237-255-62.eu-west-3.compute.amazonaws.com",
                            "public_ip": "15.237.255.62"
                        },
                        "attachment": {
                            "attach_time": "2025-01-16T11:53:50+00:00",
                            "attachment_id": "eni-attach-089a8be5d338d8ede",
                            "delete_on_termination": true,
                            "device_index": 0,
                            "network_card_index": 0,
                            "status": "attached"
                        },
                        "description": "",
                        "groups": [
                            {
                                "group_id": "sg-02960fe46d335a9eb",
                                "group_name": "terraform-20250116115338026800000002"
                            }
                        ],
                        "interface_type": "interface",
                        "ipv6_addresses": [],
                        "mac_address": "06:3f:78:ba:6a:43",
                        "network_interface_id": "eni-0266412a62b9a53c4",
                        "operator": {
                            "managed": false
                        },
                        "owner_id": "817539924586",
                        "private_dns_name": "ip-10-0-1-44.eu-west-3.compute.internal",
                        "private_ip_address": "10.0.1.44",
                        "private_ip_addresses": [
                            {
                                "association": {
                                    "ip_owner_id": "amazon",
                                    "public_dns_name": "ec2-15-237-255-62.eu-west-3.compute.amazonaws.com",
                                    "public_ip": "15.237.255.62"
                                },
                                "primary": true,
                                "private_dns_name": "ip-10-0-1-44.eu-west-3.compute.internal",
                                "private_ip_address": "10.0.1.44"
                            }
                        ],
                        "source_dest_check": true,
                        "status": "in-use",
                        "subnet_id": "subnet-0c74c3492086ed03c",
                        "vpc_id": "vpc-09945a4acbcb4394b"
                    }
                ],
                "network_performance_options": {
                    "bandwidth_weighting": "default"
                },
                "operator": {
                    "managed": false
                },
                "owner_id": "817539924586",
                "placement": {
                    "availability_zone": "eu-west-3a",
                    "group_name": "",
                    "region": "eu-west-3",
                    "tenancy": "default"
                },
                "platform_details": "Linux/UNIX",
                "private_dns_name": "ip-10-0-1-44.eu-west-3.compute.internal",
                "private_dns_name_options": {
                    "enable_resource_name_dns_a_record": false,
                    "enable_resource_name_dns_aaaa_record": false,
                    "hostname_type": "ip-name"
                },
                "private_ip_address": "10.0.1.44",
                "product_codes": [],
                "public_dns_name": "ec2-15-237-255-62.eu-west-3.compute.amazonaws.com",
                "public_ip_address": "15.237.255.62",
                "requester_id": "",
                "reservation_id": "r-077eaa2b7041041e2",
                "root_device_name": "/dev/sda1",
                "root_device_type": "ebs",
                "security_groups": [
                    {
                        "group_id": "sg-02960fe46d335a9eb",
                        "group_name": "terraform-20250116115338026800000002"
                    }
                ],
                "source_dest_check": true,
                "state": {
                    "code": 16,
                    "name": "running"
                },
                "state_transition_reason": "",
                "subnet_id": "subnet-0c74c3492086ed03c",
                "tags": {
                    "Group": "ansible",
                    "Name": "ansible2"
                },
                "usage_operation": "RunInstances",
                "usage_operation_update_time": "2025-01-16T11:53:50+00:00",
                "virtualization_type": "hvm",
                "vpc_id": "vpc-09945a4acbcb4394b"
            },
            "ec2-35-180-134-1.eu-west-3.compute.amazonaws.com": {
                "ami_launch_index": 0,
                "ansible_host": "35.180.134.1",
                "architecture": "x86_64",
                "block_device_mappings": [
                    {
                        "device_name": "/dev/sda1",
                        "ebs": {
                            "attach_time": "2025-01-16T11:53:51+00:00",
                            "delete_on_termination": true,
                            "status": "attached",
                            "volume_id": "vol-074befc02bfd01a30"
                        }
                    }
                ],
                "boot_mode": "uefi-preferred",
                "capacity_reservation_specification": {
                    "capacity_reservation_preference": "open"
                },
                "client_token": "terraform-20250116115349348200000004",
                "cpu_options": {
                    "core_count": 1,
                    "threads_per_core": 1
                },
                "current_instance_boot_mode": "legacy-bios",
                "ebs_optimized": false,
                "ena_support": true,
                "enclave_options": {
                    "enabled": false
                },
                "hibernation_options": {
                    "configured": false
                },
                "hypervisor": "xen",
                "image_id": "ami-09be70e689bddcef5",
                "instance_id": "i-08681c69fabef7ddc",
                "instance_type": "t2.micro",
                "key_name": "lecture32",
                "launch_time": "2025-01-16T11:53:50+00:00",
                "maintenance_options": {
                    "auto_recovery": "default"
                },
                "metadata_options": {
                    "http_endpoint": "enabled",
                    "http_protocol_ipv6": "disabled",
                    "http_put_response_hop_limit": 2,
                    "http_tokens": "required",
                    "instance_metadata_tags": "disabled",
                    "state": "applied"
                },
                "monitoring": {
                    "state": "disabled"
                },
                "network_interfaces": [
                    {
                        "association": {
                            "ip_owner_id": "amazon",
                            "public_dns_name": "ec2-35-180-134-1.eu-west-3.compute.amazonaws.com",
                            "public_ip": "35.180.134.1"
                        },
                        "attachment": {
                            "attach_time": "2025-01-16T11:53:50+00:00",
                            "attachment_id": "eni-attach-03bdf86d3d7f32b85",
                            "delete_on_termination": true,
                            "device_index": 0,
                            "network_card_index": 0,
                            "status": "attached"
                        },
                        "description": "",
                        "groups": [
                            {
                                "group_id": "sg-02960fe46d335a9eb",
                                "group_name": "terraform-20250116115338026800000002"
                            }
                        ],
                        "interface_type": "interface",
                        "ipv6_addresses": [],
                        "mac_address": "06:1a:2f:f2:dd:1b",
                        "network_interface_id": "eni-0ee46e0d2bf7369e6",
                        "operator": {
                            "managed": false
                        },
                        "owner_id": "817539924586",
                        "private_dns_name": "ip-10-0-1-83.eu-west-3.compute.internal",
                        "private_ip_address": "10.0.1.83",
                        "private_ip_addresses": [
                            {
                                "association": {
                                    "ip_owner_id": "amazon",
                                    "public_dns_name": "ec2-35-180-134-1.eu-west-3.compute.amazonaws.com",
                                    "public_ip": "35.180.134.1"
                                },
                                "primary": true,
                                "private_dns_name": "ip-10-0-1-83.eu-west-3.compute.internal",
                                "private_ip_address": "10.0.1.83"
                            }
                        ],
                        "source_dest_check": true,
                        "status": "in-use",
                        "subnet_id": "subnet-0c74c3492086ed03c",
                        "vpc_id": "vpc-09945a4acbcb4394b"
                    }
                ],
                "network_performance_options": {
                    "bandwidth_weighting": "default"
                },
                "operator": {
                    "managed": false
                },
                "owner_id": "817539924586",
                "placement": {
                    "availability_zone": "eu-west-3a",
                    "group_name": "",
                    "region": "eu-west-3",
                    "tenancy": "default"
                },
                "platform_details": "Linux/UNIX",
                "private_dns_name": "ip-10-0-1-83.eu-west-3.compute.internal",
                "private_dns_name_options": {
                    "enable_resource_name_dns_a_record": false,
                    "enable_resource_name_dns_aaaa_record": false,
                    "hostname_type": "ip-name"
                },
                "private_ip_address": "10.0.1.83",
                "product_codes": [],
                "public_dns_name": "ec2-35-180-134-1.eu-west-3.compute.amazonaws.com",
                "public_ip_address": "35.180.134.1",
                "requester_id": "",
                "reservation_id": "r-0261817297eeb4a88",
                "root_device_name": "/dev/sda1",
                "root_device_type": "ebs",
                "security_groups": [
                    {
                        "group_id": "sg-02960fe46d335a9eb",
                        "group_name": "terraform-20250116115338026800000002"
                    }
                ],
                "source_dest_check": true,
                "state": {
                    "code": 16,
                    "name": "running"
                },
                "state_transition_reason": "",
                "subnet_id": "subnet-0c74c3492086ed03c",
                "tags": {
                    "Group": "ansible",
                    "Name": "ansible1"
                },
                "usage_operation": "RunInstances",
                "usage_operation_update_time": "2025-01-16T11:53:50+00:00",
                "virtualization_type": "hvm",
                "vpc_id": "vpc-09945a4acbcb4394b"
            }
        }
    },
    "all": {
        "children": [
            "ansible_ansible",
            "aws_ec2",
            "ungrouped"
        ]
    },
    "ansible_ansible": {
        "hosts": [
            "ec2-15-237-255-62.eu-west-3.compute.amazonaws.com",
            "ec2-35-180-134-1.eu-west-3.compute.amazonaws.com"
        ]
    },
    "aws_ec2": {
        "hosts": [
            "ec2-15-237-255-62.eu-west-3.compute.amazonaws.com",
            "ec2-35-180-134-1.eu-west-3.compute.amazonaws.com"
        ]
    }
}

vladv@vvovk-lp:~/devops/devops-r-d/lecture-32$ ansible-playbook -i aws_ec2.yml playbook.yml --ask-vault-pass --private-key lecture32.pem
Vault password: 
[WARNING]: Collection amazon.aws does not support Ansible version 2.13.13

PLAY [Configure all servers] *************************************************************************************************************

TASK [Gathering Facts] *******************************************************************************************************************
ok: [ec2-15-237-255-62.eu-west-3.compute.amazonaws.com]
ok: [ec2-35-180-134-1.eu-west-3.compute.amazonaws.com]

TASK [baseline : Installing basic packages] **********************************************************************************************
ok: [ec2-15-237-255-62.eu-west-3.compute.amazonaws.com]
ok: [ec2-35-180-134-1.eu-west-3.compute.amazonaws.com]

TASK [baseline : Configuring SSH-keys] ***************************************************************************************************
ok: [ec2-15-237-255-62.eu-west-3.compute.amazonaws.com]
ok: [ec2-35-180-134-1.eu-west-3.compute.amazonaws.com]

TASK [baseline : Check Secret] ***********************************************************************************************************
ok: [ec2-35-180-134-1.eu-west-3.compute.amazonaws.com] => {
    "msg": "SQL pass supersecret"
}
ok: [ec2-15-237-255-62.eu-west-3.compute.amazonaws.com] => {
    "msg": "SQL pass supersecret"
}

PLAY [Configure ansible servers] *********************************************************************************************************

TASK [Gathering Facts] *******************************************************************************************************************
ok: [ec2-15-237-255-62.eu-west-3.compute.amazonaws.com]
ok: [ec2-35-180-134-1.eu-west-3.compute.amazonaws.com]

TASK [nginx : Installing Nginx] **********************************************************************************************************
ok: [ec2-15-237-255-62.eu-west-3.compute.amazonaws.com]
ok: [ec2-35-180-134-1.eu-west-3.compute.amazonaws.com]

TASK [nginx : Set up Nginx] **************************************************************************************************************
ok: [ec2-15-237-255-62.eu-west-3.compute.amazonaws.com]
ok: [ec2-35-180-134-1.eu-west-3.compute.amazonaws.com]

TASK [nginx : Deploy index.html] *********************************************************************************************************
ok: [ec2-15-237-255-62.eu-west-3.compute.amazonaws.com]
ok: [ec2-35-180-134-1.eu-west-3.compute.amazonaws.com]

PLAY [Configure firewall rules] **********************************************************************************************************

TASK [Gathering Facts] *******************************************************************************************************************
ok: [ec2-15-237-255-62.eu-west-3.compute.amazonaws.com]
ok: [ec2-35-180-134-1.eu-west-3.compute.amazonaws.com]

TASK [firewall : Enable UFW] *************************************************************************************************************
ok: [ec2-15-237-255-62.eu-west-3.compute.amazonaws.com]
ok: [ec2-35-180-134-1.eu-west-3.compute.amazonaws.com]

TASK [firewall : Allow SSH] **************************************************************************************************************
ok: [ec2-15-237-255-62.eu-west-3.compute.amazonaws.com]
ok: [ec2-35-180-134-1.eu-west-3.compute.amazonaws.com]

TASK [firewall : Allow HTTP and HTTPS] ***************************************************************************************************
ok: [ec2-15-237-255-62.eu-west-3.compute.amazonaws.com]
ok: [ec2-35-180-134-1.eu-west-3.compute.amazonaws.com]

PLAY RECAP *******************************************************************************************************************************
ec2-15-237-255-62.eu-west-3.compute.amazonaws.com : ok=12   changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
ec2-35-180-134-1.eu-west-3.compute.amazonaws.com : ok=12   changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0  