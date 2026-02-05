#Networking Guardrail
# Prevents devioers from creating their own Internet Gateways. 

resource "aws_organizations_policy" "network_lockdown" {
  name        = "ProfCloud-Network-Governance"
  description = "Centralized Networking: Prevents unauthorized Internet Gateway creation."

  depends_on = [aws_organizations_organization.prof_cloud]

  content = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Sid    = "DenyIGWCreation"
      Effect = "Deny"
      Action = [
        "ec2:CreateInternetGateway",
        "ec2:AttachInternetGateway",
        "ec2:CreateVpcPeeringConnection"
      ]
      Resource = "*" # Thisa condition here to allow it only in specific accounts.
    }]
  })
}

# Attach to DevOps
resource "aws_organizations_policy_attachment" "devops_network_attach" {
  policy_id = aws_organizations_policy.network_lockdown.id
  target_id = aws_organizations_organizational_unit.units["DevOps"].id
}