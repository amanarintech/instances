data "terraform_remote_state" "network_details" {
  backend = "s3"
  config = {
    bucket = "student.3-my-aman-bucket"
    key    = "student.3-network-state"
    region = var.region
  }
}

module "webserver" {
  source = "./modules/linux_node"
  ami    = "ami-0e2c8caa4b6378d8c"
  instance_count = "0"
  instance = "t2.micro"
  key_name = data.terraform_remote_state.network_details.outputs.key_name
  subnet_id = data.terraform_remote_state.network_details.outputs.my_subnet
  vpc_security_group_ids = data.terraform_remote_state.network_details.outputs.security_group_id_array
  tags = {
    Name = var.webserver_prefix
         }
         install_package = "webservers"
         playbook_name = "install-apache.yaml"
}


module "loadbalancer" {
  source = "./modules/linux_node"
  instance_count = "0"
  ami = "ami-0e2c8caa4b6378d8c"
  instance = "t2.micro"
  key_name = data.terraform_remote_state.network_details.outputs.key_name
  subnet_id = data.terraform_remote_state.network_details.outputs.my_subnet
  vpc_security_group_ids = data.terraform_remote_state.network_details.outputs.security_group_id_array
tags = {
    Name = var.loadbalancer_prefix
  }
    install_package = "loadbalancer"
    playbook_name   = "install-ha-proxy.yaml"
    depends_on = [module.webserver]
}

module "web_docker_host" {
  source = "./modules/linux_node"
  instance_count = "0"
  ami = "ami-0e2c8caa4b6378d8c"
  instance = "t2.micro"
  key_name = data.terraform_remote_state.network_details.outputs.key_name
  subnet_id = data.terraform_remote_state.network_details.outputs.my_subnet
  vpc_security_group_ids = data.terraform_remote_state.network_details.outputs.security_group_id_array
tags = {
    Name = var.web_docker_host_prefix
  }
    install_package = "dockerhost"
    playbook_name   = "install-docker.yaml"
    depends_on = [module.webserver]
}

module "lb_docker_host"{
  source = "./modules/linux_node"
  ami = "ami-0e2c8caa4b6378d8c"
  instance = "t2.micro"
  instance_count = "1"
  subnet_id = data.terraform_remote_state.network_details.outputs.my_subnet
  key_name = data.terraform_remote_state.network_details.outputs.key_name
  vpc_security_group_ids = data.terraform_remote_state.network_details.outputs.security_group_id_array
tags = {
    Name = var.lb_docker_host_prefix
  }
    install_package = "loadbalancer_docker"
    playbook_name = "install-lb-docker-host.yaml"
    depends_on = [module.web_docker_host]
}
