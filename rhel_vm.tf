
##################################################################
# Data sources to get VPC, subnet, security group and AMI details
##################################################################
# data "aws_vpc" "default" {
#   default = true
# }

variable "ec2_key_pair_name" {
    type = string
    description = "The EC2 key pair name"
  
}
variable "ec2_instance_type" {
    type = string
    description = "The EC2 instance type" 
  default = "t3.small"
  
}
variable "rhel_ami" {
    type        = string
    description = "The RHEL AMI Image to use"
}

data "aws_subnets" "all" {
  filter {
    name   = "vpc-id"
    values = [aws_vpc.tf_vpc.id] 
  }
}

/*

data "aws_ami" "amazon_linux" {
  most_recent = true

  filter {
    name = "name"

    values = [
      "amzn-ami-hvm-*-x86_64-gp2",
    ]
  }

  filter {
    name = "owner-alias"

    values = [
      "amazon",
    ]
  }
}
*/

resource "aws_network_interface" "rhel_public_interface" {
  subnet_id   = aws_subnet.public_subnet.id

  tags = {
    Name = "public_network_interface"
  }
}

resource "aws_network_interface" "rhel_private_interface" {
  subnet_id   = aws_subnet.private_subnet.id

  tags = {
    Name = "private_network_interface"
  }
}

resource "aws_instance" "rhel_webserver" {
  ami = var.rhel_ami
  instance_type = "${var.ec2_instance_type}"


  network_interface {
    network_interface_id = aws_network_interface.rhel_public_interface.id 
    device_index         = 0
  }

  tags = {
    Name = "RHEL-VM"
  }

  key_name = var.ec2_key_pair_name
}


resource "aws_network_interface_sg_attachment" "internalattachment" {
  depends_on           = [aws_network_interface.rhel_public_interface]
  security_group_id    = aws_security_group.public_allow.id
  network_interface_id = aws_network_interface.rhel_public_interface.id
}