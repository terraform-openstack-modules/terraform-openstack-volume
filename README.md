# Objetivo
Este módulo tem por objetivo o reaproveitamento do código e a padronização no provisionamento de volumes para instâncias no Openstack.

## Requisitos
Foram considerados os seguintes itens para a construção de volumes:
<pre>
<b>1. Count.</b>
   1.1. Quantidade de volume(s) à ser(em) criado(s).
<b>2. Instance_id.</b>
   2.1. A referência do ID da instância para associação do(s) volume(s).
<b>3. Instance_name.</b>
   3.1. Nome da instância para criação do volume com a descrição através do nome.
<b>4. Size.</b>
   4.1. Definição do tamanho do volume(s) à ser(em) criado(s).
</pre>

### Exemplo 1
#### Definição de um volume para uma instância:
<pre>
<b>module "frontend-vol"</b> {
  source        = "terraform-openstack-modules/volume/openstack"
  version       = "0.0.1"
  <b>count         = "1"</b>
  <b>instance_id   = "${module.frontend.id}"</b>
  <b>instance_name = "${module.frontend.name}"</b>
  size          = "10"
  
}

<b>module "frontend-instance"</b> {
  source            = "terraform-openstack-modules/instance/openstack"
  version           = "0.0.3"
  <b>count             = "1"</b>
  hostname          = "frontend-srv"
  availability_zone = ["zone-decimo"]
  dns               = "localdomain"
  network           = "privatenetwork"
  key_pair          = "host-key"
  flavor            = "small-1"
  fixed_ip_v4       = ["192.168.0.10"]
  <b>secgroup_id       = ["${module.frontend-sg.id}"]</b>
  env               = "hom"
  puppet_server     = "puppet-master.localdomain"
  puppet_ip         = "172.16.15.30"
}

<b>module "frontend-sg"</b> {
  source      = "terraform-openstack-modules/securitygroup/openstack"
  version     = "0.0.2"
  name        = "Instance - secgroup"
  description = "Instance security group project"
  <b>rules       = "${frontend-rules-sg}"</b>
}

<b>variable "frontend-rules-sg"</b> {
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
   ]
 }  
 </pre>
 
 ### Exemplo 2
 #### Definição de quatro volumes distribuidos em duas instâncias iguais:
 <pre>
<b>module "frontend-vol"</b> {
  source        = "terraform-openstack-modules/volume/openstack"
  version       = "0.0.1"
  <b>count         = "4"</b>
  <b>instance_id   = "${module.frontend-instance.id}"</b>
  <b>instance_name = "${module.frontend-instance.name}"</b>
  size          = "10"
  
}

<b>module "frontend-instance"</b> {
  source            = "terraform-openstack-modules/instance/openstack"
  version           = "0.0.3"
  <b>count             = "2"</b>
  availability_zone = ["zone-decimo","zone-oitavo"]
  hostname          = "frontend-srv"
  dns               = "localdomain"
  network           = "privatenetwork"
  key_pair          = "host-key"
  flavor            = "small-1"
  fixed_ip_v4       = ["192.168.0.10"]
  <b>secgroup_id       = ["${module.frontend-sg.id}"]</b>
  env               = "hom"
  puppet_server     = "puppet-master.localdomain"
  puppet_ip         = "172.16.15.30"
}

<b>module "frontend-sg"</b> {
  source      = "terraform-openstack-modules/securitygroup/openstack"
  version     = "0.0.2"
  name        = "Instance - secgroup"
  description = "Instance security group project"
  <b>rules       = "${frontend-rules-sg}"</b>
}

<b>variable "frontend-rules-sg"</b> {
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
   ]
}
 </pre>
 
 ### Exemplo 3
 #### Definição de quatro volumes distribuidos em duas instâncias distintas:
<pre>
<b>module "frontend-vol"</b> {
  source        = "terraform-openstack-modules/volume/openstack"
  version       = "0.0.1"
  <b>count         = "4"</b>
  <b>instance_id   = "${module.frontend-instance.id}"</b>
  <b>instance_name = "${module.frontend-instance.name}"</b>
  size          = "10"
  
}

<b>module "backend-vol"</b> {
  source        = "terraform-openstack-modules/volume/openstack"
  version       = "0.0.1"
  <b>count         = "4"</b>
  <b>instance_id   = "${module.backend-instance.id}"</b>
  <b>instance_name = "${module.backend-instance.name}"</b>
  size          = "10"
}

<b>module "frontend-instance"</b> {
  source            = "terraform-openstack-modules/instance/openstack"
  version           = "0.0.3"
  <b>count             = "2"</b>  
  availability_zone = ["zone-decimo","zone-oitavo"]
  hostname          = "frontend-srv"
  dns               = "localdomain"
  network           = "privatenetwork"
  key_pair          = "host-key"
  flavor            = "large-1"
  fixed_ip_v4       = ["192.168.0.10","192.168.0.11"]
  <b>secgroup_id       = ["${module.default-sg.id}"]</b>
  env               = "hom"
  puppet_server     = "puppet-master.localdomain"
  puppet_ip         = "172.16.15.30"
}

<b>module "backend-instance"</b> {
  source            = "terraform-openstack-modules/instance/openstack"
  version           = "0.0.3"
  <b>count             = "2"</b>
  availability_zone = ["zone-decimo","zone-oitavo"]
  hostname          = "backend-srv"
  dns               = "localdomain"
  network           = "privatenetwork"
  key_pair          = "host-key"
  flavor            = "medium-1"
  fixed_ip_v4       = ["192.168.0.12","192.168.0.13"]
  <b>secgroup_id       = ["${module.instance-sg.id}"]</b>
  env               = "hom"
  puppet_server     = "puppet-master.localdomain"
  puppet_ip         = "172.16.15.30"
}

<b>module "default-sg"</b> {
  source      = "terraform-openstack-modules/securitygroup/openstack"
  version     = "0.0.2"
  name        = "Instance - secgroup"
  description = "Instance security group project"
  <b>rules       = "${default-rules-sg}"</b>
}

<b>variable "default-rules-sg"</b> {
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
    ]
}
 </pre>
