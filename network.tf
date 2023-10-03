variable "aws_region_az" {
  type = string
  description = "The AZ"
}
variable "private_subnet_vpc_range" {
    type        = string
    description = "The VPC network address space"
    default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
    type        = string
    description = "Public Subnet CIDR values"
    default     = "10.0.1.0/24"
}
 
variable "private_subnet_cidrs" {
    type        = string
    description = "Private Subnet CIDR values"
    default     = "10.0.2.0/24"
}

variable "aws_region" {
    type = string
    description = "The AWS Region to deploy into"
    default = "eu-west-1"
}

variable "demo_tag" {
    type = string
    description = "The default tag applied to all elements created as part of this demo."
    default = "Ansiform Demo"
}


resource "aws_vpc" "tf_vpc" {
 cidr_block = var.private_subnet_vpc_range
 
 tags = {
   Name = "Ansible / Terraform Learning"
   Demo = var.demo_tag
 }
}


resource "aws_subnet" "public_subnet" {

 vpc_id     = aws_vpc.tf_vpc.id
 cidr_block = var.public_subnet_cidrs
 availability_zone = var.aws_region_az
 
 tags = {
   Name = "Public Subnet"
   Demo = var.demo_tag
 }
}

resource "aws_subnet" "private_subnet" {

 vpc_id     = aws_vpc.tf_vpc.id
 cidr_block = var.private_subnet_cidrs
 availability_zone = var.aws_region_az
 
 tags = {
   Name = "Private Subnet"
   Demo = var.demo_tag
 }
}


resource "aws_internet_gateway" "gw" {
 vpc_id = aws_vpc.tf_vpc.id
 
 tags = {
   Name = "Project VPC IG"
   Demo = var.demo_tag
 }
}


resource "aws_eip" "public_eip" {
  depends_on                = [aws_instance.rhel_webserver]
  vpc                       = true
  network_interface         = "${aws_network_interface.rhel_public_interface.id}"
  associate_with_private_ip = aws_network_interface.rhel_public_interface.private_ip
}


####################################################################################################


// Route Table
resource "aws_route_table" "rt_public_subnet" {
  vpc_id = aws_vpc.tf_vpc.id 

  tags = {
    Name = "Public Subnet Route Table"
  }
}

resource "aws_route_table" "rt_private_subnet" {
  vpc_id = aws_vpc.tf_vpc.id 

  tags = {
    Name = "Private Subnet Route Table"
  }
}

// routing out of the public subnet
resource "aws_route" "externalroute" {
  route_table_id         = aws_route_table.rt_public_subnet.id 
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gw.id 
}


resource "aws_route" "internalroute" {
  depends_on             = [aws_instance.rhel_webserver]
  route_table_id         = aws_route_table.rt_private_subnet.id
  destination_cidr_block = "0.0.0.0/0"
  network_interface_id   = aws_network_interface.rhel_private_interface.id 

}

resource "aws_route_table_association" "public1associate" {
  subnet_id      = aws_subnet.public_subnet.id 
  route_table_id = aws_route_table.rt_public_subnet.id 
}

resource "aws_route_table_association" "internalassociate" {
  subnet_id      = aws_subnet.private_subnet.id 
  route_table_id = aws_route_table.rt_private_subnet.id 
}

// Security Group

resource "aws_security_group" "public_allow" {
  name        = "Public Allow"
  description = "Public Allow traffic"
  vpc_id      = aws_vpc.tf_vpc.id 


  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "6"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "6"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8443
    to_port     = 8443
    protocol    = "6"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 2222
    to_port     = 2222
    protocol    = "6"
    cidr_blocks = ["0.0.0.0/0"]
  }

    ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "6"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Public Allow"
  }
}

resource "aws_security_group" "allow_all" {
  name        = "Allow All"
  description = "Allow all traffic"
  vpc_id      = aws_vpc.tf_vpc.id 

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Public Allow"
  }
}
