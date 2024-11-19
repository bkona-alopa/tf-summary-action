resource "random_string" "random" {
  count            = 4
  length           = 16
  special          = true
  override_special = "/@£$"
}

output "test_output" {
  value = random_string.random[*].result
}
