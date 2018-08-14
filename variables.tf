variable "count" {
  type    = "string"
  default = 1
}

variable "availability_zone" {
  type    = "string"
  default = ""
}

variable "region" {
  type    = "string"
  default = ""
}

variable "instance_name" {
  type    = "list"
  default = [""]
}

variable "size" {
  type    = "string"
  default = "30"
}

variable "instance_id" {
  type    = "list"
  default = [""]
}
