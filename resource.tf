resource "aws_default_vpc" "default" {}

resource "aws_instance" "demo_instance" {
  count                  = var.instance_count
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.instance_sg.id]

  root_block_device {
    volume_size = var.root_vol_size  # Root volume size in GB
    volume_type = var.root_vol_type
  }

  tags = {
    Name = "demo_instance_${count.index}"
  }
}



resource "aws_security_group" "instance_sg" {
  name_prefix = "instance_sg"
  description = "Allow inbound traffic on port 22, 80 & 8080"
  vpc_id      = aws_default_vpc.default.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 9000
    to_port     = 9000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "null_resource" "copy_ssh_key" {
    depends_on = [aws_instance.demo_instance]
    
    # Add count to replicate the resource based on the number of instances.
    count = var.instance_count

    connection {
        type = "ssh"
        host = aws_instance.demo_instance[count.index].public_ip
        user = "ubuntu" 
        private_key = file("~/mtc-terransible.pem") # Change to your private key path
    } 
    
    provisioner "remote-exec" {
      inline = [
            "echo '${file("~/.ssh/id_rsa.pub")}' >> ~/.ssh/authorized_keys",  # Change to your public key
             "echo 'Copy Completed'"
      ]
    }
   
}