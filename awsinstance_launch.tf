provider "aws" {
   region = "us-east-1"
   shared_credentials_file = "/root/.aws/credentials"
}
resource "aws_vpc" "my_vpc" {
    cidr_block = "190.160.0.0/16"
    instance_tenancy = "default"
    tags {
        Name = "vpc1"
}
}
resource "aws_subnet" "my_subnet" {
    vpc_id = "${aws_vpc.my_vpc.id}"
    cidr_block = "190.160.1.0/24"
    tags {
        Name = "subnet1"
     }
}
resource "aws_security_group" "my_security"
    {
    name = "my_security"
    description = "security group created by me"
   vpc_id =  "${aws_vpc.my_vpc.id}"
    ingress {
      from_port = 443
      to_port = 443
      protocol = "tcp"
}
}
#resource "aws_instance" "myinstance" {
#    ami = "ami-02da3a138888ced85"
#    key_name = "dummy001"
#    instance_type = "t2.micro"
#}
data "aws_ami" "ubuntu" {
  most_recent = true
  #filter {
  #name = "name"
  #values = ["*amazon-ecs-optimized"]
  #}
  filter {
  name = "virtualization-type"
  values = ["hvm"]
}
 owners = ["502984197442"]
}
resource "aws_instance" "web" {
ami = "${data.aws_ami.ubuntu.id}"
instance_type = "t2.micro"
tags = {
  Name = "HelloWorld"
}
}
resource "aws_lb" "test" {
   name = "myloadbalancer"
   load_balancer_type = "application"
   subnets = ["${aws_subnet.my_subnet.id}"]
}
#############
