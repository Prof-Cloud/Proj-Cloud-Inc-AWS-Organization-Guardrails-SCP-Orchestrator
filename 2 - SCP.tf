# Regional Lock SCP 
# Enforces data residency
# this prevents resources from being created outside of approved regions (USA and Canada)

resource "aws_organizations_policy" "region_lock" {
  name        = "ProfCloud-Region-Lock"
  description = "Restricts all services to North America (Virginia/Canada)"
  depends_on  = [aws_organizations_organization.prof_cloud]

  content = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Sid       = "DenyOutsideHQRegions"
      Effect    = "Deny"
      NotAction = ["iam:*", "organizations:*", "route53:*", "cloudfront:*"]
      Resource  = "*"
      Condition = {
        StringNotEquals = { "aws:RequestedRegion" : ["us-east-1", "ca-central-1"] }
      }
    }]
  })
}

# Attach SCP to the Root
# Applying the lock at the root so it trickles down to every single account.
resource "aws_organizations_policy_attachment" "root_attach" {
  policy_id = aws_organizations_policy.region_lock.id
  target_id = aws_organizations_organization.prof_cloud.roots[0].id

  # This forces Terraform to wait until the policy is 100% confirmed by AWS.
  depends_on = [aws_organizations_policy.region_lock]

}
