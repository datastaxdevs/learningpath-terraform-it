resource "aws_instance" "redis" {
  ami             = "ami-0e6de310858faf4dc"
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.ssh.name, aws_security_group.outgoing.name, aws_security_group.redis.name]
  key_name        = aws_key_pair.deployer.key_name
  connection {
    user        = "ec2-user"
    host        = self.public_ip
    private_key = file("~/.ssh/id_rsa")
  }
  provisioner "remote-exec" {
    inline = [
      "docker run -dp 6379:6379 redis",
    ]
  }
  tags = {
    Name = "redis"
  }
}
resource "aws_instance" "db" {
  ami             = "ami-0e6de310858faf4dc"
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.ssh.name, aws_security_group.postgres.name, aws_security_group.outgoing.name]
  key_name        = aws_key_pair.deployer.key_name
  connection {
    user        = "ec2-user"
    host        = self.public_ip
    private_key = file("~/.ssh/id_rsa")
  }
  provisioner "remote-exec" {
    inline = [
      "docker run -dp 5432:5432 -e POSTGRES_HOST_AUTH_METHOD=trust postgres",
    ]
  }
  tags = {
    Name = "postgresql"
  }
}
resource "aws_instance" "voting" {
  ami             = "ami-0e6de310858faf4dc"
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.ssh.name, aws_security_group.http.name, aws_security_group.outgoing.name]
  key_name        = aws_key_pair.deployer.key_name
  connection {
    user        = "ec2-user"
    host        = self.public_ip
    private_key = file("~/.ssh/id_rsa")
  }
  provisioner "remote-exec" {
    inline = [
      "docker run -dp 80:80 -e REDIS_HOST=${aws_instance.redis.private_ip} ditmc/voting",
    ]
  }
  tags = {
    Name = "voting-fe"
  }
}
resource "aws_instance" "worker" {
  ami             = "ami-0e6de310858faf4dc"
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.ssh.name, aws_security_group.outgoing.name]
  key_name        = aws_key_pair.deployer.key_name
  connection {
    user        = "ec2-user"
    host        = self.public_ip
    private_key = file("~/.ssh/id_rsa")
  }
  provisioner "remote-exec" {
    inline = [
      "docker run -d -e REDIS_HOST=${aws_instance.redis.private_ip} -e DB_HOST=${aws_instance.db.private_ip} ditmc/worker"
    ]
  }
  tags = {
    Name = "worker"
  }
}
resource "aws_instance" "result" {
  ami             = "ami-0e6de310858faf4dc"
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.ssh.name, aws_security_group.http.name, aws_security_group.outgoing.name]
  key_name        = aws_key_pair.deployer.key_name
  connection {
    user        = "ec2-user"
    host        = self.public_ip
    private_key = file("~/.ssh/id_rsa")
  }
  provisioner "remote-exec" {
    inline = [
      "docker run -dp 80:80 -e DB_HOST=${aws_instance.db.private_ip} ditmc/result"
    ]
  }
  tags = {
    Name = "result-fe"
  }
}
resource "aws_eip" "voting_ip" {
  instance = aws_instance.voting.id
}
resource "aws_eip" "db_ip" {
  instance = aws_instance.db.id
}
resource "aws_eip" "result_ip" {
  instance = aws_instance.result.id
}


output "aws_result_ip" {
  value = aws_eip.result_ip.public_ip
}
output "aws_voting_ip" {
  value = aws_eip.voting_ip.public_ip
}
