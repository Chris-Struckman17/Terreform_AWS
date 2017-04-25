provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "example" {
  ami = "ami-40d28157"
  //Interpolates the security groups id to call that secruity group
  vpc_security_group_ids = ["${aws_security_group.instance.id}"]
  instance_type = "t2.micro"
  user_data = //Runs simple web server that returns hello World
          <<-EOF
          #!/bin/bash
          echo "Hello, World" > index.html
          nohup busybox httpd -f -p 8080 &
          EOF
  tags {
    Name = "terraform-example"
  }
}
//Secruity group allows for the incoming and outgoing traffic in AWS, as that is not the default
resource "aws_security_group" "instance" {
  name = "terraform-example-instance"
  ingress{

    //Runs on 8080, limiting the persmissions come an attack
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    //cidr_blocks allows for any IP address
    cidr_blocks = ["0.0.0.0/0"]
  }
}
