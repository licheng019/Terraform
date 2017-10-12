############################################################
# OUTPUT 
############################################################

output "ambari_agent_public_dns" {
  value = "${aws_instance.ambari_agent.*.private_ip}"
}

output "ambari_server_public_dns" {
  value = "${aws_instance.ambari_server.*.private_ip}"
}

