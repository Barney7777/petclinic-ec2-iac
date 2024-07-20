# Create IAM role for EC2 instance
data "aws_iam_policy_document" "assume_role_ec2" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "ec2_iam_role" {
  name               = "${var.project_name}-${var.environment}-EC2-SSM-Role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_ec2.json
}

# Attach AmazonSSMManagedInstanceCore policy to the IAM role
resource "aws_iam_role_policy_attachment" "ec2_role_policy_attachment" {
  role       = aws_iam_role.ec2_iam_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# Attach AmazonEC2ContainerRegistryFullAccess policy to the IAM role
resource "aws_iam_role_policy_attachment" "ecr_role_policy_attachment" {
  role       = aws_iam_role.ec2_iam_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
}

# Define the policy document for accessing Secrets Manager
data "aws_iam_policy_document" "secrets_manager_policy" {
  statement {
    effect = "Allow"
    actions = [
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret",
    ]
    resources = ["*"] # Ideally, restrict this to specific secret ARNs
  }
}

# Create the custom policy for accessing Secrets Manager
resource "aws_iam_policy" "secrets_manager_policy" {
  name   = "${var.project_name}-${var.environment}-SecretsManagerPolicy"
  policy = data.aws_iam_policy_document.secrets_manager_policy.json
}

# Attach the custom policy to the IAM role
resource "aws_iam_role_policy_attachment" "secrets_manager_policy_attachment" {
  role       = aws_iam_role.ec2_iam_role.name
  policy_arn = aws_iam_policy.secrets_manager_policy.arn
}

# Create an instance profile for the EC2 instance and associate the IAM role
resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "${var.project_name}-${var.environment}-EC2-SSM-Instance-Profile"
  role = aws_iam_role.ec2_iam_role.name
}