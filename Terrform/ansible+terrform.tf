provider "aws" {
   region = "us-east-2"
   access_key = ""
   secret_key = ""
}

resource "aws_instance" "terra1" {
 ami   = "ami-00399ec92321828f5"
 instance_type = "t2.micro"
 key_name = "Vikasaws"
 security_groups = [ "webserver2" ]

tags = {
    Name = "terra1"
  }

provisioner "remote-exec" {
    inline = ["echo 'wait till the SSH is ready'"]

connection {
    type     = "ssh"
    user     = "ubuntu"
    private_key = file("Vikasaws.pem")
    host     = aws_instance.terra1.public_ip
  }
}

provisioner "local-exec" {
  command = "ansible-playbook -i ${aws_instance.terra1.public_ip}, --private-key 'Vikasaws.pem' wp.yml"
}
}

output "server_ip" {
  value = aws_instance.terra1.public_ip
}

