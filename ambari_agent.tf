############################################################
# RESOURCES 
############################################################

resource "aws_instance" "ambari_agent" {
  ami = "${var.agent_ami}"
  count = "${var.agent_instance_count}"
  instance_type = "${var.agent_instance_type}"
  subnet_id = "${var.agent_subnet_id}"
  root_block_device {
    volume_size = "${var.agent_volume_size}"
    volume_type = "${var.agent_volume_type}"
    delete_on_termination = "${var.agent_volume_delete_on_termination}"
  }
  tags {
    Name = "${var.agent_hostname_prefix}${format("%03d", count.index + 1)}${var.agent_hostname_postfix}"
    BI_Project = "${var.agent_ec2_bi_project_tag}"
  }
  security_groups = ["${var.agent_security_groups}"]
  key_name = "${var.access_key_pair_name}"
  connection = {
    type        = "${var.ssh_connection_type}"
    user        = "${var.agent_ssh_connection_user}"
    private_key = "${file("${var.private_key_path}")}"
  }
  depends_on = ["aws_instance.ambari_server"]

  provisioner "remote-exec" {
    inline = ["sudo hostnamectl set-hostname --static ${var.agent_hostname_prefix}${format("%03d", count.index + 1)}${var.agent_hostname_postfix}",
              "echo 'preserve_hostname: true' | sudo tee -a /etc/cloud/cloud.cfg",
              "sudo reboot"]
  }
}

resource "aws_ebs_volume" "create_hadoop_ebs_volumes" {
    count = "${var.agent_instance_count}"
    availability_zone = "${element(aws_instance.ambari_agent.*.availability_zone, count.index)}"
    size = "${var.agent_ebs_volume_size}"
    type = "${var.agent_ebs_volume_type}"
    tags {
        Name = "${var.agent_hostname_prefix}${format("%03d", count.index + 1)}:${var.agent_ebs_mount_point}"
        BI_Project = "${var.agent_ebs_bi_project_tag}"
    }
}

resource "aws_volume_attachment" "attach_hadoop_ebs_volumes" {
  count = "${var.agent_instance_count}"
  device_name = "/dev/sdh"
  volume_id   = "${element(aws_ebs_volume.create_hadoop_ebs_volumes.*.id, count.index)}"
  instance_id = "${element(aws_instance.ambari_agent.*.id, count.index)}"
}

resource "null_resource" "configure_ebs_volumes" {
  depends_on = ["aws_volume_attachment.attach_hadoop_ebs_volumes"]
  count = "${var.agent_instance_count}"

  connection {
    type        = "${var.ssh_connection_type}"
    user        = "${var.agent_ssh_connection_user}"
    private_key = "${file("${var.private_key_path}")}"
    host = "${element(aws_instance.ambari_agent.*.private_ip, count.index)}"
  }

  provisioner "remote-exec" {
    when   = "destroy"
    inline = ["sudo umount /mnt/hadoop"]
  }

  provisioner "remote-exec" {
    inline = ["sudo parted /dev/xvdh mklabel gpt",
              "sudo parted -a optimal /dev/xvdh mkpart primary 0% 100%",
              "sudo yum install xfsprogs -y",
              "sudo mkfs.xfs -f /dev/xvdh1",
              "sudo mkdir ${var.agent_ebs_mount_point}",
              "sudo mount -t xfs /dev/xvdh1 ${var.agent_ebs_mount_point}",
              "echo '/dev/xvdh1     ${var.agent_ebs_mount_point}    xfs     defaults        0 0' | sudo tee -a /etc/fstab",
              "sudo chown -R ${var.agent_ssh_connection_user}:${var.agent_ssh_connection_user} ${var.agent_ebs_mount_point}",
              "sudo reboot"]
  }
}
