#######################################
# Ambari Agent specefic variables
#######################################

# EC2
agent_ec2_bi_project_tag           = "Hadoop Core"
agent_ami                          = "" # CentOS Linux 7
agent_instance_type                = ""
agent_instance_count               = 2
agent_subnet_id                    = "" # eu-west-1a
agent_security_groups              =  "" # default
agent_volume_size                  = 50
agent_volume_type                  = "gp2"
agent_volume_delete_on_termination = true
agent_hostname_prefix              = "" # such as hostname_prefix 
agent_hostname_postfix             = "" # such as hostname_postfix
agent_ssh_connection_user          ="centos"

# EBS volumes
agent_ebs_bi_project_tag           = ""
agent_ebs_volume_size              = 60
agent_ebs_volume_type              = "gp2"
agent_ebs_mount_point              = "/mnt/hadoop"