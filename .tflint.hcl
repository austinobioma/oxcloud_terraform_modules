# tflint - v0.24.1
#
# docs: https://github.com/terraform-linters/tflint/tree/v0.24.1

config {
    # we don't have cross module references in this code
    module = false
}

# this checks the guidelines set out in 
# https://www.terraform.io/docs/modules/structure.html
#

rule "terraform_standard_module_structure" {
    enabled = true
}

# dead/deprecated code analysis
rule "terraform_deprecated_index" {
    enabled = true
}
rule "terraform_deprecated_interpolation" {
    enabled = true
}
rule "terraform_unused_declarations" {
    enabled = true
}

# requirements for all terraform code
rule "terraform_required_version" {
    enabled = true
}

plugin "aws" {
  enabled = true
  version = "0.4.3"
  source  = "github.com/terraform-linters/tflint-ruleset-aws"
}

rule "aws_route_specified_multiple_targets" {
  enabled = false
}