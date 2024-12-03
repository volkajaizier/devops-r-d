Creating and Configuring a VPC

* Create a New VPC:
* Use the AWS Console to create a VPC.
* Select a CIDR Block
![Alt text](images/Create_VPC.png)
* Create Two Subnets in the VPC:
* Create One Public Subnet with a CIDR Block.
* Create One Private Subnet with a CIDR Block.
![Alt text](images/Public_Private_subnet.png)
* Create and Configure an Internet Gateway:
* Associate the Internet Gateway with your VPC.
![Alt text](images/IGW.png)
* Configure the Route Tables to Provide Internet Access from the Public Subnet.
![Alt text](images/route_public_network.png)
2. Configure Security Groups and Access Control Lists (ACLs)

* Add Rules to Allow Inbound HTTP and SSH Traffic from Any IP Address.
![Alt text](images/Create_security_group.png)
3. Launch an EC2 Instance

* Launch a New EC2 Instance:
* Use the Amazon Linux 2 AMI.
* Select an Instance Type, such as t2.micro. Since it is free.
* Bind the instance to a public subnet.
* Use the Security Group created in the previous step.
* Download and use the SSH key to access the instance.
![Alt text](images/EC2.png)
4. Assign an Elastic IP Address (EIP)

* Create and assign an EIP to your instance:
* Create a new EIP in the AWS console.
* Bind the EIP to a running EC2 instance.
![Alt text](images/assign_EIP.png)