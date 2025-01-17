variable "instance_count" {
  type    = number
  default = 1
}


variable "ami_id" {
  type    = string
  default = "ami-0a0e5d9c7acc336f1"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "key_name" {
  type    = string
  default = "mtc-terransible"
}

variable "root_vol_type" {
   type   = string
   default = "gp3"
}

variable "root_vol_size" {
   type   = number
   default = 25
}