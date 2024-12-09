variable "instance" {
 default = "t2.micro"
}

variable "region" {
  default = "us-east-1" 
}

variable "ami" {
 default = "ami-0e2c8caa4b6378d8c" 
}

variable "profile" {
 default = "student.3"
}

variable "webserver_prefix" {
 default = "student.3-webserver-vm"
}

variable "loadbalancer_prefix" {
 default = "student.3-loadbalancer-vm"
}

variable "web_docker_host_prefix" {
 default = "student.3-docker-vm"
}

variable "lb_docker_host_prefix" {
 default = "student.3-lb_docker_host-vm"
}

variable "jenkins_master_prefix" {
 default = "student.3-jenkins-vm"
}
