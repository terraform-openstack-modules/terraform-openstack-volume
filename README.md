# Objetivo
Este módulo tem por objetivo o reaproveitamento do código e a padronização no provisionamento de volumes para instâncias no Openstack.

## Requisitos
Foram considerados os seguintes itens para a construção de volumes:
1. Count.
2. Instance_id.
3. Instance_name.
4. Size.

## Exemplos: 
### Definição de um volume para uma instância
<pre>
module "instance-vol" {
  source        = "terraform-openstack-modules/volume/openstack"
  version       = "0.0.1"
  <b>count         = "1"</b>
  instance_id   = "${module.instance.id}"
  instance_name = "${module.instance.name}"
  size          = "10"
  
}

module "instance" {
  source        = "terraform-openstack-modules/instance/openstack"
  version       = "0.0.1"
  <b>count         = "1"</b>
  hostname      = "frontend-srv"
  dns           = "localdomain"
  network       = "privatenetwork"
  key_pair      = "host-key"
  flavor        = "small-1"
  fixed_ip_v4   = ["192.168.0.10"]
  secgroup_id   = ["${module.instance-sg.id}"]
  env           = "hom"
  puppet_server = "puppet-master.localdomain"
  puppet_ip     = "172.16.15.30"
}

module "instance-sg" {
  source              = "terraform-openstack-modules/securitygroup/openstack"
  version             = "0.0.1"
  securitygroup_name  = "Instance - secgroup"
  securitygroup_desc  = "Instance security group project"
  securitygroup_rules = ${instance-rules-sg}
}

variable "instance-rules-sg" {
    default = [
      {
        port_range_min   = 22
        port_range_max   = 22
        protocol         = "tcp"
        ethertype        = "IPv4"
        direction        = "ingress"
        remote_ip_prefix = "0.0.0.0/0"
      },
      {
        port_range_min   = 0
        port_range_max   = 0
        protocol         = "icmp"
        ethertype        = "IPv4"
        direction        = "ingress"
        remote_ip_prefix = "0.0.0.0/0"
      }
 }  
 </pre>
 
 ### Definição de dois volumes para duas instâncias iguais
 <pre>
module "instance-vol" {
  source        = "terraform-openstack-modules/volume/openstack"
  version       = "0.0.1"
  <b>count         = "4"</b>
  instance_id   = "${module.instance.id}"
  instance_name = "${module.instance.name}"
  size          = "10"
  
}

module "instance" {
  source        = "terraform-openstack-modules/instance/openstack"
  version       = "0.0.1"
  <b>count         = "2"</b>
  hostname      = "frontend-srv"
  dns           = "localdomain"
  network       = "privatenetwork"
  key_pair      = "host-key"
  flavor        = "small-1"
  fixed_ip_v4   = ["192.168.0.10"]
  secgroup_id   = ["${module.instance-sg.id}"]
  env           = "hom"
  puppet_server = "puppet-master.localdomain"
  puppet_ip     = "172.16.15.30"
}

module "instance-sg" {
  source              = "terraform-openstack-modules/securitygroup/openstack"
  version             = "0.0.1"
  securitygroup_name  = "Instance - secgroup"
  securitygroup_desc  = "Instance security group project"
  securitygroup_rules = ${instance-rules-sg}
}

variable "instance-rules-sg" {
    default = [
      {
        port_range_min   = 22
        port_range_max   = 22
        protocol         = "tcp"
        ethertype        = "IPv4"
        direction        = "ingress"
        remote_ip_prefix = "0.0.0.0/0"
      },
      {
        port_range_min   = 0
        port_range_max   = 0
        protocol         = "icmp"
        ethertype        = "IPv4"
        direction        = "ingress"
        remote_ip_prefix = "0.0.0.0/0"
      }
}
 </pre>
 
 ### Definição de dois volumes para duas instâncias distintas
 <pre>
module "instance-frontend-vol" {
  source        = "terraform-openstack-modules/volume/openstack"
  version       = "0.0.1"
  <b>count         = "4"</b>
  instance_id   = "${module.instance-frontend.id}"
  instance_name = "${module.instance-frontend.name}"
  size          = "10"
  
}

module "instance-backend-vol" {
  source        = "terraform-openstack-modules/volume/openstack"
  version       = "0.0.1"
  <b>count         = "4"</b>
  instance_id   = "${module.instance-backend.id}"
  instance_name = "${module.instance-backend.name}"
  size          = "10"
}

module "instance-frontend" {
  source        = "terraform-openstack-modules/instance/openstack"
  version       = "0.0.1"
  <b>count         = "2"</b>
  hostname      = "frontend-srv"
  dns           = "localdomain"
  network       = "privatenetwork"
  key_pair      = "host-key"
  flavor        = "large-1"
  fixed_ip_v4   = ["192.168.0.10","192.168.0.11"]
  secgroup_id   = ["${module.instance-sg.id}"]
  env           = "hom"
  puppet_server = "puppet-master.localdomain"
  puppet_ip     = "172.16.15.30"
}

module "instance-backend" {
  source        = "terraform-openstack-modules/instance/openstack"
  version       = "0.0.1"
  <b>count         = "2"</b>
  hostname      = "backend-srv"
  dns           = "localdomain"
  network       = "privatenetwork"
  key_pair      = "host-key"
  flavor        = "medium-1"
  fixed_ip_v4   = ["192.168.0.12","192.168.0.13"]
  secgroup_id   = ["${module.instance-sg.id}"]
  env           = "hom"
  puppet_server = "puppet-master.localdomain"
  puppet_ip     = "172.16.15.30"
}

module "instance-sg" {
  source              = "terraform-openstack-modules/securitygroup/openstack"
  version             = "0.0.1"
  securitygroup_name  = "Instance - secgroup"
  securitygroup_desc  = "Instance security group project"
  securitygroup_rules = ${instance-rules-sg}
}

variable "instance-rules-sg" {
    default = [
      {
        port_range_min   = 22
        port_range_max   = 22
        protocol         = "tcp"
        ethertype        = "IPv4"
        direction        = "ingress"
        remote_ip_prefix = "0.0.0.0/0"
      },
      {
        port_range_min   = 0
        port_range_max   = 0
        protocol         = "icmp"
        ethertype        = "IPv4"
        direction        = "ingress"
        remote_ip_prefix = "0.0.0.0/0"
      }
}
 </pre>
