terraform {
  required_providers {
    ansible = {
      source = "ansible/ansible"
      version = "1.1.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}


