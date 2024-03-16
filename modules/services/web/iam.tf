data "aws_iam_policy_document" "assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ec2_s3_full_access_role" {
  name_prefix = var.name
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}


data "aws_iam_policy_document" "s3_full_access_policy" {
  statement {
    effect    = "Allow"
    actions   = ["s3:*"]
    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "wordpress" {
  role = aws_iam_role.ec2_s3_full_access_role.id
  policy = data.aws_iam_policy_document.s3_full_access_policy.json
}

resource "aws_iam_instance_profile" "wordpress" {
  role   = aws_iam_role.ec2_s3_full_access_role.name
}

