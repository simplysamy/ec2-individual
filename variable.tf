variable "instance_count" {
  type    = number
  default = 1
}

variable "az" {
  type    = string
  default = "us-east-1a"
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

variable "ebs_type" {
   type   = string
   default = "gp3"
}

variable "ebs_size" {
   type   = number
   default = 25
}