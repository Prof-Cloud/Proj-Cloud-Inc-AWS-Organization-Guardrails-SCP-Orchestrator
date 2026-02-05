# Financial Guardrail (Cost Control)
# This policy prevents anyone in the DevOps or Admin OUs from dpinning up massive, expensive GPU instances that wreck the budget.
resource "aws_organizations_policy" "cost_guardrail" {
  name        = "ProfCloud-Cost-Control"
  description = "Budget Protection: Denies expensive GPU and high-memory instances."

  depends_on = [aws_organizations_organization.prof_cloud]

  content = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid      = "DenyExpensiveInstances"
        Effect   = "Deny"
        Action   = "ec2:RunInstances"
        Resource = "arn:aws:ec2:*:*:instance/*"
        Condition = {
          # Listed the wallet-killer instances here. 
          # Anything in the p3 or g4 family is blocked.
          "StringLike" = {
            "ec2:InstanceType" = [
              "p2.*",
              "p3.*",
              "g4.*",
              "r5.24xlarge",
              "m5.24xlarge"
            ]
          }
        }
      }
    ]
  })
}

# Attach Cost Guardrail to DevOps OU
resource "aws_organizations_policy_attachment" "devops_cost_attach" {
  policy_id = aws_organizations_policy.cost_guardrail.id
  target_id = aws_organizations_organizational_unit.units["DevOps"].id
}

# 5. Attach Cost Guardrail to Administrative OU 
resource "aws_organizations_policy_attachment" "admin_cost_attach" {
  policy_id  = aws_organizations_policy.cost_guardrail.id
  target_id  = aws_organizations_organizational_unit.units["Administrative"].id
  depends_on = [aws_organizations_policy.cost_guardrail]
}