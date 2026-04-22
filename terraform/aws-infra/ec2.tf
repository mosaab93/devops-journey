# ── KEY PAIR للـ SSH ──
resource "aws_key_pair" "main" {
  key_name   = "mosaab-key"
  public_key = file("~/.ssh/id_ed25519.pub")
}

# ── EC2 INSTANCE ──
resource "aws_instance" "web" {
  ami                    = "ami-0c02fb55956c7d316"  # Amazon Linux 2
  instance_type          = "t2.micro"               # Free tier
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.ec2.id]
  key_name               = aws_key_pair.main.key_name

  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y nginx
    systemctl start nginx
    systemctl enable nginx
    echo "<h1>Mosaab DevOps Journey 🚀</h1>" > /usr/share/nginx/html/index.html
  EOF

  tags = {
    Name      = "mosaab-web-server"
    ManagedBy = "Terraform"
  }
}

# ── ELASTIC IP للـ EC2 ──
resource "aws_eip" "ec2" {
  instance = aws_instance.web.id
  domain   = "vpc"

  tags = {
    Name = "mosaab-ec2-eip"
  }
}

# ── OUTPUT: إيه الـ IP بتاع الـ server ──
output "server_ip" {
  value       = aws_eip.ec2.public_ip
  description = "Public IP of the web server"
}
