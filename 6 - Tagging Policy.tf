# Tag Policy
# Forices every resources to be labeled with a Department so we know exactly who is spending what
resource "aws_organizations_policy" "tag_policy" {
  name        = "ProfCloud-Tag-Standard"
  description = "Ensures every resource is tagged with a Department for cost tracking."
  type        = "TAG_POLICY"

  # It prevents the "NotInUseException" by forcing a sequence.
  depends_on = [aws_organizations_organization.prof_cloud]

  content = jsonencode({
    tags = {
      # This forces the key Department to exist
      Department = {
        tag_key = { "@@assign" = "Department" }
        # This restricts the values to ONLY our 4 organization units
        tag_value = { "@@assign" = ["DevOps", "Finance", "Security", "Admin"] }
        # We apply this specifically to the big money-spenders: EC2 and S3
        enforced_for = { "@@assign" = ["ec2:instance", "s3:bucket"] }
      }
    }
  })
}

# Attaching it to the root so the entire company follows the same rules.
resource "aws_organizations_policy_attachment" "root_tag_attach" {
  policy_id = aws_organizations_policy.tag_policy.id
  target_id = aws_organizations_organization.prof_cloud.roots[0].id

  # Just like the SCPs, we want to make sure the policy exists before attaching.
  depends_on = [aws_organizations_policy.tag_policy]
}