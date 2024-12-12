resource "aws_instance" "servers" {
    count=2
    ami = var.ami
    key_name = var.key_name
    instance_type = var.instance_type
    vpc_security_group_ids = [aws_security_group.sg.id]
    subnet_id = element(aws_subnet.public.*.id,count.index)
    private_ip = element(var.private_ip.*,count.index)
    associate_public_ip_address = true
    user_data = <<-EOF
    #!/bin/bash
    sudo apt update -y
    sudo apt install apache2 -y
    sudo systemctl start apache2
    sudo apt install openjdk-17-jre-headless -y
    EOF
    tags = {
        Name = "${var.vpc_name}-server${count.index+1}"
    }

  }
  resource "aws_instance" "privateserver" {
    count=1
    ami = var.ami
    key_name = var.key_name
    instance_type = var.instance_type
    vpc_security_group_ids = [aws_security_group.sg.id]
    subnet_id = element(aws_subnet.private.*.id,count.index)
    private_ip = element(var.private1_ip,count.index)
    iam_instance_profile = var.profile
    user_data = <<-EOF
    #!/bin/bash
    sudo apt update -y
    sudo apt install openjdk-17-jre-headless -y
    sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]" \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update
sudo apt-get install jenkins
EOF
tags = {
  Name = "privateserver"
}



    
  }