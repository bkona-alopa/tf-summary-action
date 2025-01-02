# resource "random_string" "random" {
#   for_each         = local.final
#   length           = 16
#   special          = true
#   override_special = "/@£$"
# }

locals {
  test = true

}

# output "test_output" {
#   value = compact(flatten([random_string.random[*].result, local.test ? "1" : ""]))
# }

variable "certificate-domain-details" {
  type = map(object({
    domain_name     = list(string)
    url_prefix      = string
    certificate_arn = string
    resource_prefix = string
  }))
  description = "To Create Multiple Cloudfronts used for Domains. Contains header, domain and certificate-arn details. Certificate_arn must be from 'us-east-1' region. Leave 'certificate_arn' as empty string, if the certificate is created at account level and passed to ENV"
}
variable "teva-hosts" {
  type = list(any)
}
locals {
  domain_name       = toset([for k, v in var.certificate-domain-details : v.url_prefix != "" ? "resource-${v.url_prefix}.${v.domain_name[0]}" : "resource.${v.domain_name[0]}"])
  domain_names_list = toset(distinct([for k, v in var.certificate-domain-details : "${v.domain_name}"]))
}

locals {
  monitoring_app_url_list = length(var.teva-hosts) != 0 ? [["cologuard", "cloguard.url", "/auth/abxyrz"], ["regenronclient", "regeneron.url", "/rgnclient/123"], ["rgenronserver", "regeneron.url", "/rgnserver/api/apidocs/"], ["teva", var.teva-hosts[0], "/api/apidocs/"]] : [["cologuard", "cloguard.url", "/auth/abxyrz"], ["regenronclient", "regeneron.url", "/rgnclient/123"], ["rgenronserver", "regeneron.url", "/rgnserver/api/apidocs/"]]
  monitoring_resource_url_list = [
    for record in local.domain_name :
  [record, record, "/LastUploadedGitCommit"]]

  monitoring_list = concat(local.monitoring_app_url_list, local.monitoring_resource_url_list)

  hosted_zone = distinct(compact([for k, v in var.certificate-domain-details : v.resource_prefix != "" ? v.domain_name[0] : ""]))

  final = flatten([for k in local.domain_name : [
    for x in local.hosted_zone : {
      domain   = x
      resource = k
    }
    ]
  ])

  test1 = { for k in local.final : "${k.domain}.${k.resource}" => k }

}
output "test_ste" {
  value = local.test_ste
}
output "final" {
  value = local.resource_domain_names_list
}

locals {
  resource_domain_names_map = {
    for k in compact([
      for k, v in var.certificate-domain-details : v.resource_prefix != "" ? k : ""
      ]) : k => merge(
      var.certificate-domain-details[k],
      {
        resource_url = var.certificate-domain-details[k].url_prefix != "" ? "resource-${var.certificate-domain-details[k].url_prefix}.${var.certificate-domain-details[k].domain_name[0]}" : "resource.${var.certificate-domain-details[k].domain_name[0]}"
      }
    )
  }
  resource_domain_names_map_test = {}

  resource_domain_names_list = [for k, v in local.resource_domain_names_map : v.resource_url]


  resource_domain_names_list_test = { for k, v in local.resource_domain_names_map_test : k => v.resource_url }
  test_ste                        = toset(local.resource_domain_names_list)
}

output "resource_domain_names_list_test" {
  value = local.resource_domain_names_list_test
}
