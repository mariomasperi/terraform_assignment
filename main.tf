# Provider configuration
provider "aws" {
  #version = "5.0.1"
  region = "us-east-2" # region
}

# Create a VPC
resource "aws_vpc" "webpage_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "webpage_vpc"
  }
}

# Create public subnets
resource "aws_subnet" "public_subnet_1" {
  vpc_id                  = aws_vpc.webpage_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-2a"
  tags = {
    Name = "public_subnet_1"
  }
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id                  = aws_vpc.webpage_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-2b"
  tags = {
    Name = "public_subnet_2"
  }
}

resource "aws_subnet" "public_subnet_3" {
  vpc_id                  = aws_vpc.webpage_vpc.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "us-east-2a"
  tags = {
    Name = "public_subnet_3"
  }
}

resource "aws_subnet" "public_subnet_4" {
  vpc_id                  = aws_vpc.webpage_vpc.id
  cidr_block              = "10.0.4.0/24"
  availability_zone       = "us-east-2b"
  tags = {
    Name = "public_subnet_4"
  }
}


# Create internet gateway
resource "aws_internet_gateway" "webpage_igw" {
  vpc_id = aws_vpc.webpage_vpc.id
  tags = {
    Name = "internet_gateway"
  }
}


# Create route table for public subnets
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.webpage_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.webpage_igw.id
  }

  tags = {
    Name = "route_table"
  }
}


# Associate public subnets with the route table
resource "aws_route_table_association" "public_subnet_1_association" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_route_table.id

}

resource "aws_route_table_association" "public_subnet_2_association" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_route_table.id

}

resource "aws_route_table_association" "public_subnet_3_association" {
  subnet_id      = aws_subnet.public_subnet_3.id
  route_table_id = aws_route_table.public_route_table.id

}

resource "aws_route_table_association" "public_subnet_4_association" {
  subnet_id      = aws_subnet.public_subnet_4.id
  route_table_id = aws_route_table.public_route_table.id

}


resource "aws_eip" "nat_public_ip" {
  vpc = true
}
# Create NAT gateway and update route table for private subnets
resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_public_ip.id
  subnet_id     = aws_subnet.public_subnet_1.id
  depends_on = [aws_internet_gateway.webpage_igw]

}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.webpage_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }

  tags = {
    Name = "private_route_table"
  }


}

/*
resource "aws_route" "private_subnet_route" {
  route_table_id         = aws_route_table.private_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gateway.id
  depends_on = [aws_internet_gateway.webpage_igw]
}*/

# Create private subnets
resource "aws_subnet" "private_subnet_1" {
  vpc_id                  = aws_vpc.webpage_vpc.id
  cidr_block              = "10.0.101.0/24"
  availability_zone       = "us-east-2a"
  tags = {
    Name = "private_subnet_1"
  }
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id                  = aws_vpc.webpage_vpc.id
  cidr_block              = "10.0.102.0/24"
  availability_zone       = "us-east-2b"
  tags = {
    Name = "private_subnet_2"
  }
}

resource "aws_subnet" "private_subnet_3" {
  vpc_id                  = aws_vpc.webpage_vpc.id
  cidr_block              = "10.0.103.0/24"
  availability_zone       = "us-east-2a"
  tags = {
    Name = "private_subnet_3"
  }
}

resource "aws_subnet" "private_subnet_4" {
  vpc_id                  = aws_vpc.webpage_vpc.id
  cidr_block              = "10.0.104.0/24"
  availability_zone       = "us-east-2b"
  tags = {
    Name = "private_subnet_4"
  }
}
# Associate private subnets with private route table
resource "aws_route_table_association" "private_route_table_association_1" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "private_route_table_association_2" {
  subnet_id      = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "private_route_table_association_3" {
  subnet_id      = aws_subnet.private_subnet_3.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "private_route_table_association_4" {
  subnet_id      = aws_subnet.private_subnet_4.id
  route_table_id = aws_route_table.private_route_table.id
}

# Create network ACL
resource "aws_network_acl" "public_network_acl" {
  vpc_id = aws_vpc.webpage_vpc.id

  ingress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port        = 0
    to_port          = 0
  }

  egress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port        = 0
    to_port          = 0
  }

  tags = {
    Name = "public_network_acl"
  }
}

resource "aws_network_acl" "private_network_acl" {
  vpc_id = aws_vpc.webpage_vpc.id

  ingress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port        = 0
    to_port          = 0
  }

  egress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port        = 0
    to_port          = 0
  }

  tags = {
    Name = "private_network_acl"
  }
/*
  ingress {
    rule_no       = 100
    protocol      = "tcp"
    action        = "allow"
    cidr_block    = "0.0.0.0/0"
    from_port     = 80
    to_port       = 80
  }

  egress {
    rule_no       = 100
    protocol      = "tcp"
    action        = "allow"
    cidr_block    = "0.0.0.0/0"
    from_port     = 0
    to_port       = 65535
  } */
}
# Create network ACL associations for public subnets
resource "aws_network_acl_association" "public_network_acl_association_1" {
  subnet_id          = aws_subnet.public_subnet_1.id
  network_acl_id     = aws_network_acl.public_network_acl.id
}

resource "aws_network_acl_association" "public_network_acl_association_2" {
  subnet_id          = aws_subnet.public_subnet_2.id
  network_acl_id     = aws_network_acl.public_network_acl.id
}

resource "aws_network_acl_association" "public_network_acl_association_3" {
  subnet_id          = aws_subnet.public_subnet_3.id
  network_acl_id     = aws_network_acl.public_network_acl.id
}

resource "aws_network_acl_association" "public_network_acl_association_4" {
  subnet_id          = aws_subnet.public_subnet_4.id
  network_acl_id     = aws_network_acl.public_network_acl.id
}
# Associate private network ACL with private subnets
resource "aws_network_acl_association" "private_network_acl_association_1" {
  subnet_id          = aws_subnet.private_subnet_1.id
  network_acl_id     = aws_network_acl.private_network_acl.id
}

resource "aws_network_acl_association" "private_network_acl_association_2" {
  subnet_id          = aws_subnet.private_subnet_2.id
  network_acl_id     = aws_network_acl.private_network_acl.id
}

resource "aws_network_acl_association" "private_network_acl_association_3" {
  subnet_id          = aws_subnet.private_subnet_3.id
  network_acl_id     = aws_network_acl.private_network_acl.id
}

resource "aws_network_acl_association" "private_network_acl_association_4" {
  subnet_id          = aws_subnet.private_subnet_4.id
  network_acl_id     = aws_network_acl.private_network_acl.id
}
# Create security group
resource "aws_security_group" "webpage_sg" {
  name        = "webpage-security-group"
  description = "Security group for the webpage"

  vpc_id = aws_vpc.webpage_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    #cidr_blocks = [aws_subnet.public_subnet_1.cidr_block,aws_subnet.public_subnet_2.cidr_block,
    #aws_subnet.public_subnet_3.cidr_block, aws_subnet.public_subnet_4.cidr_block,]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    #cidr_blocks = [aws_subnet.private_subnet_1.cidr_block, aws_subnet.private_subnet_2.cidr_block,
    #aws_subnet.private_subnet_3.cidr_block, aws_subnet.private_subnet_4.cidr_block,]
  }
}

/*
resource "aws_security_group_rule" "webpage_ssh_inbound" {
  security_group_id = aws_security_group.webpage_sg.id
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}


resource "aws_security_group_rule" "webpage_http_outbound" {
  security_group_id = aws_security_group.webpage_sg.id
  type              = "egress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}*/

/*
resource "aws_security_group_rule" "webpage_ssh_outbound" {
  security_group_id = aws_security_group.webpage_sg.id
  type              = "egress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

# Output the VPC ID
output "vpc_id" {
  value = aws_vpc.webpage_vpc.id
}
*/


# Create load balancer 1
resource "aws_lb" "webpage_lb_1" {
  name               = "webpage-lb-1"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.webpage_sg.id]
  subnets            = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]

  /*
  subnet_mapping {
    subnet_id = aws_subnet.public_subnet_1.id
  }

  subnet_mapping {
    subnet_id = aws_subnet.public_subnet_2.id
  }*/

  tags = {
    Name = "webpage-lb-1"
  }

}

# Create load balancer 2
resource "aws_lb" "webpage_lb_2" {
  name               = "webpage-lb-2"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.webpage_sg.id]
  subnets            = [aws_subnet.public_subnet_3.id, aws_subnet.public_subnet_4.id]

  /*
  subnet_mapping {
    subnet_id = aws_subnet.public_subnet_3.id
  }

  subnet_mapping {
    subnet_id = aws_subnet.public_subnet_4.id
  }*/

  tags = {
    Name = "webpage-lb-2"
  }


  }


  /*
resource "aws_lb" "webpage_lb_2" {
  name               = "webpage-lb-2"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.webpage_sg.id]
  #subnets            = [aws_subnet.public_subnet_2.id]


  subnet_mapping {
    subnet_id = aws_subnet.public_subnet_2.id
  }
}
*/



# Create target group 1
resource "aws_lb_target_group" "webpage_target_group_1" {
  name     = "webpage-target-group-1"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.webpage_vpc.id

  health_check {
    enabled             = true
    protocol            = "HTTP"
    port                = 80
    path                = "/var/www/html/index.html"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 30
  }
}

# Create target group 2
resource "aws_lb_target_group" "webpage_target_group_2" {
  name     = "webpage-target-group-2"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.webpage_vpc.id

  health_check {
    enabled             = true
    protocol            = "HTTP"
    port                = 80
    path                = "/var/www/html/index.html"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 30
  }


}


# Create listener for load balancer 1
resource "aws_lb_listener" "webpage_listener_1" {
  load_balancer_arn = aws_lb.webpage_lb_1.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.webpage_target_group_1.arn
  }

}

# Create listener for load balancer 2
resource "aws_lb_listener" "webpage_listener_2" {
  load_balancer_arn = aws_lb.webpage_lb_2.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.webpage_target_group_2.arn
  }

}

/*
# Create launch configuration
resource "aws_launch_configuration" "webpage_launch_configuration" {
  name          = "webpage-launch-configuration"
  image_id      = "ami-05842f1afbf311a43"  # AMI ID
  instance_type = "t2.micro"
  key_name      = "EC2-key-pair"
  security_groups             = [aws_security_group.webpage_sg.id]
  associate_public_ip_address = true



  user_data = <<-EOF
    #!/bin/bash
    echo "<html><body><h1>Web Page test!</h1></body></html>" > /var/www/html/index.html
    sudo yum update -y
    sudo yum install -y httpd
    sudo systemctl start httpd
    sudo systemctl enable httpd

    # Install EC2 Instance Connect
    sudo yum install -y amazon-ec2-instance-connect
    sudo systemctl enable ec2-instance-connect.service

  EOF
}
*/

data "template_file" "user_data" {
  template = <<-EOF
    #! /bin/bash
    sudo su
    sudo yum update
    sudo yum install -y httpd
    sudo chkconfig httpd on
    sudo service httpd start
    echo "<h1>Welcome to the Cloud Programming Web Page</h1>" | sudo tee /var/www/html/index.html
    EOF
}

# Create launch template
resource "aws_launch_template" "webpage_launch_template" {
  name          = "webpage-launch-template"
  image_id      = "ami-05842f1afbf311a43"  # AMI ID
  instance_type = "t2.micro"
  key_name      = "EC2-key-pair"
  #security_group_names = [aws_security_group.webpage_sg.name]
  #security_group_names        = [aws_security_group.webpage_sg.name]
  network_interfaces {
    security_groups = [aws_security_group.webpage_sg.id]
    associate_public_ip_address = true

  }
  #vpc_security_group_ids = [aws_security_group.webpage_sg.id]

  monitoring {
    enabled = true
  }

  user_data = base64encode(data.template_file.user_data.rendered)
}

  /*
  user_data = <<-EOF
    #!/bin/bash
    echo "<html><body><h1>Web Page test!</h1></body></html>" > /var/www/html/index.html
    sudo yum update -y
    sudo yum install -y httpd
    sudo systemctl start httpd
    sudo systemctl enable httpd
  EOF
  */



# Create auto scaling group
resource "aws_autoscaling_group" "webpage_autoscaling_group" {
  name                      = "webpage-autoscaling-group"
  #launch_configuration      = aws_launch_configuration.webpage_launch_configuration.name
  min_size                  = 2
  max_size                  = 4
  desired_capacity          = 2

  launch_template {
    id      = aws_launch_template.webpage_launch_template.id
    version = "$Latest"
  }
  health_check_grace_period = 300
  health_check_type         = "EC2"
  vpc_zone_identifier       = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id,
    aws_subnet.private_subnet_3.id, aws_subnet.private_subnet_4.id ]

  target_group_arns = [
    aws_lb_target_group.webpage_target_group_1.arn,
    aws_lb_target_group.webpage_target_group_2.arn
  ]

  tag {
    key                 = "Name"
    value               = "webpage-ec2-instance"
    propagate_at_launch = true
  }
}
