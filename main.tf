terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.52.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.4.3"
    }
  }
  required_version = ">= 1.1.0"

  cloud {
    organization = "eshant-hcp-tf-test"

    workspaces {
      name = "learn-terraform-github-actions2"
    }
  }
}

provider "aws" {
  region = "us-west-2"
}

resource "random_pet" "sg" {}

# Use a known AMI ID instead of querying dynamically
resource "aws_instance" "web" {
  ami                    = "ami-00c257e12d6828491"  # Replace with your AMI ID
  instance_type          = "t2.micro"
 vpc_security_group_ids = ["sg-009e46413f6fd069e"]  # Reference the existing SG

  user_data = <<-EOF
              #!/bin/bash
              apt-get update
              apt-get install -y apache2
              sed -i -e 's/80/8080/' /etc/apache2/ports.conf
              echo "Hello World" > /var/www/html/index.html
              systemctl restart apache2
              EOF
}

output "web-address" {
  value = "${aws_instance.web.public_dns}:8080"
}
