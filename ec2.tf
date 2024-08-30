resource "aws_instance" "ec2ins" {
  ami           = "ami-066784287e358dad1"
  instance_type = var.ec2-instype
  depends_on = [ var.ec2-instype ]
  subnet_id = aws_subnet.var.websunet.id
  vpc_security_group_ids = [ aws_security_group.SG_user5.id ]
  key_name = "ec2-key"
  tags = {
    Name = "Ec2-${var.ec2-instype}"
  }
}
output "ec2out" {
  value = aws_instance.ec2ins.public_ip
}