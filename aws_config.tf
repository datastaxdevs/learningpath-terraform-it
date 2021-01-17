provider "aws" {
  profile = "default"
  region  = "eu-central-1"
}

resource "aws_key_pair" "deployer" {
  key_name   = "Terraform"
  public_key = file("~/.ssh/id_rsa.pub")
}
