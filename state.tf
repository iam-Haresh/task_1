terraform {
  backend "s3" {
    bucket = "task-tf-state"
    key    = "state/terraform.tfstate"
    region = "us-east-1"
  }
}
