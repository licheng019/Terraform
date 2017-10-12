############################################################
# VARIABLES - variables are inherited from .tfvars files
############################################################
variable "aws_access_key"                      {}
variable "aws_secret_key"                      {}
variable "region"                              {}
variable "access_key_pair_name"                {}
variable "private_key_path"                    {}
variable "ssh_connection_type"                 {}
variable "agent_ec2_bi_project_tag"            {}
variable "agent_ami"                           {}
variable "agent_instance_type"                 {}
variable "agent_instance_count"                {} 
variable "agent_subnet_id"                     {}
variable "agent_security_groups"               {}
variable "agent_volume_size"                   {}
variable "agent_volume_type"                   {}
variable "agent_volume_delete_on_termination"  {}
variable "agent_hostname_prefix"               {}
variable "agent_hostname_postfix"              {}
variable "agent_ssh_connection_user"           {}
variable "agent_ebs_bi_project_tag"            {}
variable "agent_ebs_volume_size"               {}
variable "agent_ebs_volume_type"               {}
variable "agent_ebs_mount_point"               {}
variable "server_ec2_bi_project_tag"           {}
variable "server_ami"                          {}
variable "server_instance_type"                {}
variable "server_instance_count"               {} 
variable "server_subnet_id"                    {}
variable "server_security_groups"              {}
variable "server_volume_size"                  {}
variable "server_volume_type"                  {}
variable "server_volume_delete_on_termination" {}
variable "server_hostname_prefix"              {}
variable "server_hostname_postfix"             {}
variable "server_ssh_connection_user"          {}