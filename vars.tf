variable "websubnet" {
  #default = "10.66.1.0/24"
  validation {
    condition     = can(regex("^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$", var.websubnet)) && !can(regex("^(10\\.|172\\.(1[6-9]|2[0-9]|3[0-1])\\.|192\\.168\\.)", var.websubnet))
    error_message = "The IP address must not be a private IP address."
  }
}

variable "dbsubnet" {
  default = "10.9.1.0/24"
  validation {
    condition     = can(cidrhost(var.dbsubnet, 0))
    error_message = "Please provide valid ipaddress with subnetmask,for  ex., 10.10.10.0/24."
  }

}

variable "ec2-env" {
  description = "Env in which the instance will be deployed,please input dev/test/prod in which env you want to spin the instance"
  type = list
  default = ["dev","test","prod"]
  nullable = false


}


variable "ec2-instype" {
  description = "Env in which the instance will be deployed"
  type        = map(string)
  default = {
    dev  = "t2.micro"
    test = "t2.micro"
    prod = "t2.large"

  }

}

variable "ec2-instance-region" {
  type    = string
  default = "us-east-1"

}


variable "httpport" {
  type    = number
  default = 80


}

variable "sshport" {
  type    = number
  default = 22


}