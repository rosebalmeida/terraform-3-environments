terraform {
  backend "s3" {
    bucket = "terraform-state-files-mack_iac"
    key = "terraform/terraform.tfstate"
    region = "us-east-2"
  }
}
