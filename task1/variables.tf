variable "region" {
    default = "eu-west-2" 
}

variable "amis" {
  type = "map"
  default = {
    "eu-west-2" = "ami-0a0cb6c7bcb2e4c51"
    "us-west-2" = "ami-4b32be2b"
  }
}

