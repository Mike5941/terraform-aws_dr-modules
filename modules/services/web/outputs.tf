output "ami_id" {
  value = data.aws_ami.amazon_linux2.id
}

output "private_ip" {
  value = aws_instance.web[*].private_ip
}