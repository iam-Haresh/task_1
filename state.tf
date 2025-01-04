terraform {
  backend "s3" {
    bucket = "task-tf-state-1"
    key    = "state/terraform.tfstate"
    region = "us-east-1"
  }
}
