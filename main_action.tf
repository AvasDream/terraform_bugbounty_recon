data "template_file" "install_script" {
  template = "${file("init.tpl")}"
  vars = {
    telegram_token = "${var.telegram_token}"
    telegram_id   = "${var.telegram_id}"
    recon_domains   = "${jsonencode(var.recon_domains)}"
  }
}
resource "aws_instance" "elastic" {
  ami                    = "${data.aws_ami.ubuntu.id}"
  instance_type          = "${var.instance_type}"
  vpc_security_group_ids = ["${aws_security_group.sec_elastic.id}"]
  key_name = "${var.ssh_key_name}"
  user_data = "${data.template_file.install_script.rendered}"
  tags = {
    Name = "bugbounty"
  }
  /* This local exec is just for convenience and opens the ssh sessio. */
  provisioner "local-exec" {
    command = "echo ssh -i '${var.ssh_key_path}' ubuntu@${aws_instance.elastic.public_ip}"
  }
  # More disk space
  root_block_device {
    volume_size = "20"
    volume_type = "standard"
  }
  provisioner "file" {
    source      = "scripts/main.sh"
    destination = "/home/ubuntu/main.sh"

  }
}
