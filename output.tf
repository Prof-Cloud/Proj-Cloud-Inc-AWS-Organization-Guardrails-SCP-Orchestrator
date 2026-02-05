output "ou_map" {
  value = { for k, v in aws_organizations_organizational_unit.units : k => v.id }
}

# This gives us a nice list of the OU IDs so we can use them 
# for future automation or documentation.
output "prof_cloud_org_summary" {
  value = {
    organization_id = aws_organizations_organization.prof_cloud.id
    ou_details      = { for k, v in aws_organizations_organizational_unit.units : k => v.id }
  }
}

# This is the "Grand Reveal" at the end of your deployment.
output "prof_cloud_final_report" {
  value = {
    org_id          = aws_organizations_organization.prof_cloud.id
    departments     = [for ou in aws_organizations_organizational_unit.units : ou.name]
    scp_status      = "Enabled and Attached"
    tag_policy_name = aws_organizations_policy.tag_policy.name
    audit_bucket    = aws_s3_bucket.audit_logs.id
  }
}