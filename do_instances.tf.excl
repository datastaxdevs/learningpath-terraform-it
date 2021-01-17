resource "digitalocean_droplet" "redis" {
  image    = "coreos-stable"
  region   = "ams3"
  size     = "512mb"
  name     = "redis"
  ssh_keys = [digitalocean_ssh_key.default.fingerprint]
  connection {
    user = "core"
  }
  provisioner "remote-exec" {
    inline = [
      "docker run -dp 6379:6379 redis",
    ]
  }
}
resource "digitalocean_droplet" "voting" {
  image    = "coreos-stable"
  region   = "ams3"
  size     = "512mb"
  ssh_keys = [digitalocean_ssh_key.default.fingerprint]
  name     = "voting"
  connection {
    user = "core"
  }
  provisioner "remote-exec" {
    inline = [
      "docker run -dp 80:80 -e REDIS_HOST=${digitalocean_droplet.redis.ipv4_address} ditmc/voting",
    ]
  }
}
resource "digitalocean_droplet" "worker" {
  image    = "coreos-stable"
  region   = "ams3"
  size     = "512mb"
  ssh_keys = [digitalocean_ssh_key.default.fingerprint]
  name     = "redis"
  connection {
    user = "core"
  }
  provisioner "remote-exec" {
    inline = [
      "docker run -dp 80:80 -e REDIS_HOST=${digitalocean_droplet.redis.ipv4_address} -e DB_HOST=${aws_eip.db_ip.public_ip} ditmc/worker"
    ]
  }
}
resource "digitalocean_droplet" "result" {
  image    = "coreos-stable"
  region   = "ams3"
  size     = "512mb"
  ssh_keys = [digitalocean_ssh_key.default.fingerprint]
  name     = "result"
  connection {
    user = "core"
  }
  provisioner "remote-exec" {
    inline = [
      "docker run -dp 80:80 -e DB_HOST=${aws_eip.db_ip.public_ip} ditmc/result"
    ]
  }
}
