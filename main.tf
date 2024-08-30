module "compute" {
  source ="https://github.com/Ktan109456/finalterraformlab/blob/main/ec2.tf"
  #version = "1.0.0"
  ec2name = "user5ec2-finallab"
  

}
#variable "modulebasedvpc" {
#}
module "network" {
  source = "https://github.com/Ktan109456/finalterraformlab/blob/main/vpc.tf"
  #version = "1.0.0"
  #vpcblock = var.modulebasedvpc
}

module "s3bucket" {
  source = "https://github.com/Ktan109456/finalterraformlab/blob/main/s3bucket.tf"
  #version = "1.0.0"
  }
output "vpcarn" {
  value = module.network.vpcarn
}
output "ec2pubip" {
  value = module.compute.ec2out
}