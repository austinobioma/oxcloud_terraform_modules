terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.63"
    }
    archive = {
      source = "hashicorp/archive"
    }
  }
}
