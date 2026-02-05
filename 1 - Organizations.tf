# Create the Organization

resource "aws_organizations_organization" "prof_cloud" {
  feature_set = "ALL" # Required for security policies (SCPs) to work.

  # Enabling the guardrails and billing compliant
  enabled_policy_types = ["SERVICE_CONTROL_POLICY",
  "TAG_POLICY"]
}

# Creating the departments. 
resource "aws_organizations_organizational_unit" "units" {
  for_each = toset(["DevOps", "Administrative", "Finance", "Security"])
  name     = each.value

  # This 'parent_id' ensures Terraform waits for the Org to exist first
  parent_id = aws_organizations_organization.prof_cloud.roots[0].id

}

