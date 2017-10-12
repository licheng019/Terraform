############################################################
# RESOURCES 
############################################################

resource "aws_instance" "ambari_server" {
  ami = "${var.server_ami}"
  count = "${var.server_instance_count}"
  instance_type = "${var.server_instance_type}"
  subnet_id = "${var.server_subnet_id}"
  root_block_device {
    volume_size = "${var.server_volume_size}"
    volume_type = "${var.server_volume_type}"
    delete_on_termination = "${var.server_volume_delete_on_termination}"
  }
  tags {
    Name = "${var.server_hostname_prefix}${format("%03d", count.index + 1)}${var.server_hostname_postfix}"
    BI_Project = "${var.server_ec2_bi_project_tag}"
  }
  security_groups = ["${var.server_security_groups}"]
  key_name = "${var.access_key_pair_name}"
  connection = {
    type        = "${var.ssh_connection_type}"
    user        = "${var.server_ssh_connection_user}"
    private_key = "${file("${var.private_key_path}")}"
  }
}

resource "null_resource" "configure_ambari_server" {
  count = "${var.server_instance_count}"

  connection {
    type        = "${var.ssh_connection_type}"
    user        = "${var.server_ssh_connection_user}"
    private_key = "${file("${var.private_key_path}")}"
    host = "${element(aws_instance.ambari_server.*.private_ip, count.index)}"
  }

  provisioner "remote-exec" {
    inline = ["sudo yum install wget -y",
              "sudo wget -nv http://public-repo-1.hortonworks.com/ambari/centos7/2.x/updates/2.5.1.0/ambari.repo -O /etc/yum.repos.d/ambari.repo",
              "sudo yum install ambari-server -y",
              "sudo ambari-server setup -s",
              "sudo hostnamectl set-hostname --static ${element(aws_instance.ambari_server.*.tags.Name, count.index)}",
              "echo 'preserve_hostname: true' | sudo tee -a /etc/cloud/cloud.cfg",
              "echo '${element(aws_instance.ambari_server.*.private_ip, count.index)} ${element(aws_instance.ambari_server.*.tags.Name, count.index)}' | sudo tee -a /etc/hosts",
              "sudo systemctl enable ambari-server",
              "sudo reboot"]
  }
}
