resource "aws_default_vpc" "default" {}

resource "aws_instance" "demo_instance" {
  count                  = var.instance_count
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.instance_sg.id]
}
resource "aws_ebs_volume" "my_volume" {
  availability_zone = "us-east-1a"  # Change the availability zone as needed
  size              = var.ebs_size  # Size in GB
  type              = var.ebs_type
  tags = {
    Name = "demo_volume"
  }
}

resource "aws_volume_attachment" "ebs_attachment" {
  device_name = "/dev/sdf"  # Device name to attach the volume to
  volume_id   = aws_ebs_volume.my_volume.id
  instance_id = var.ami_id # Replace with your instance ID
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
    depends_on = [aws_instance.my_instances]
    
    # Add count to replicate the resource based on the number of instances.
    count = var.instance_count

    connection {
        type = "ssh"
        host = aws_instance.my_instances[count.index].public_ip
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