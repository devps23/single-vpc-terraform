# create an instance
resource "aws_instance" "instance" {
  ami = data.aws_ami.ami.image_id
  instance_type = var.instance_type
  vpc_security_group_ids = [data.aws_security_group.def_sg.id]
  instance_market_options {
    market_type = "spot"
    spot_options {
      instance_interruption_behavior = "stop"
      spot_instance_type             = "persistent"
    }
  }
  tags = {
    Name = "${var.env}-${var.component}-demo"
    monitor = "yes"

  }
}

resource "null_resource" "null_instance" {
  connection {
    type     = "ssh"
    user     = jsondecode(data.vault_generic_secret.my_secret.data_json).username
    password = jsondecode(data.vault_generic_secret.my_secret.data_json).password
    host     = aws_instance.instance.public_ip

  }
  provisioner "remote-exec" {
    inline = [
      "sudo dnf install ansible -y",
      "sudo pip3.11 install ansible hvac",
      "ansible-pull -i localhost, -U https://github.com/devps23/expense-practice-ansible get-secrets.yml -e env=${var.env} -e component_name=${var.component} -e vault_token=${var.vault_token}",
      "ansible-pull -i localhost, -U https://github.com/devps23/expense-practice-ansible expense.yml -e env=${var.env} -e component_name=${var.component} -e @~/secrets.json -e @~/app.json"
    ]
  }
}
resource "aws_route53_record" "record" {
  name      = "${var.component}-${var.env}"
  type      = "A"
  zone_id   = var.zone_id
  ttl       = 5
  records = [aws_instance.instance.private_ip]
}


