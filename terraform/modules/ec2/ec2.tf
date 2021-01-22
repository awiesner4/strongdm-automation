locals {
  provisio_tags = {
    "provisio.installerProfile" = "starburst-strongdm-relay"
    "provisio.applicationCoordinate" = "ca.wiesner:starburst-strongdm-relay:tar.gz:${var.provisio_version}"
    "provisio.bucketPath" = "s3://starburstdata-artifacts/releases"
    "provisio.strongdmType" = var.strongdmType
    "strongdmName" = "${var.aws_account}-${var.ec2_instance_name}"
  }
}

resource "aws_instance" "main" {
  ami = data.aws_ami.ubuntu.id
  instance_type = var.ec2_instance_type
  vpc_security_group_ids = [
    var.security_group_id]
  # Take the first subnet in the set of public subnets available
  # Seems like you have to specify the subnet_id if you want a non-default vpc, it doesn't inspect the subnet
  # of the security group and try to determine anything
  subnet_id = var.selected_subnets
  key_name = var.ec2_keypair
  associate_public_ip_address = var.ec2_instance_public
  user_data = fileexists("${path.module}/${var.ec2_user_data}") ? filebase64("${path.module}/${var.ec2_user_data}") : ""
  tags = merge({
    Name = var.ec2_instance_name
  }, var.global_tags, local.provisio_tags)
  iam_instance_profile = var.ec2_instance_profile

  root_block_device {
    volume_type = var.ec2_root_block_device_type
    volume_size = var.ec2_root_block_device_size
    delete_on_termination = var.ec2_root_block_device_delete_on_termination
  }

  lifecycle {
    ignore_changes = [
      subnet_id,
    ]
  }
}

