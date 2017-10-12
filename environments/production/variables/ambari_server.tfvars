
#######################################
# Ambari Server specefic variables
#######################################

# EC2
server_ec2_bi_project_tag           = "Hadoop Core"
server_ami                          = "" # CentOS Linux 7
server_instance_type                = "t2.medium"
server_instance_count               = 1
server_subnet_id                    = " # eu-west-1a
server_security_groups              = "" # default
server_volume_size                  = 70
server_volume_type                  = "gp2"
server_volume_delete_on_termination = true
server_hostname_prefix              = "" # such as hostname_prefix
server_hostname_postfix             = "" # such as hostname_postfix
server_ssh_connection_user          = "centos"