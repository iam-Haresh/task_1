terraform {
  backend "s3" {
    bucket = "task_tf_state"
    key    = "state/terraform.tfstate"
    region = "us-east-1"
  }
}
