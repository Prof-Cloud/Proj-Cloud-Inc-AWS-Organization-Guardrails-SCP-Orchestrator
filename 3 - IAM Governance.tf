#Permission Boundaries
# This policy sets the Maximum Power limit
# Admin cannot nt delete security logs or stop CloudTrail

resource "aws_iam_policy" "devops_boundary" {
  name        = "ProfCloud-DevOps-Boundary"
  description = "Ensures DevOps users cannot disable security monitoring."

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid      = "AllowAllActions"
        Effect   = "Allow"
        Action   = "*"
        Resource = "*"
      },
      {
        Sid    = "DenyDeletingSecurityLogs"
        Effect = "Deny"
        Action = [
          "cloudtrail:DeleteTrail",
          "cloudtrail:StopLogging",
          "config:DeleteConfigRule"
        ]
        Resource = "*"
      }
    ]
  })
}

# Create a Standard Group for DevOps
resource "aws_iam_group" "devops_team" {
  name = "ProfCloud-DevOps-Team"
}
