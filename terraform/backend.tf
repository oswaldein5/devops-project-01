terraform {
  backend "s3" {
    region         = "us-east-1"
    bucket         = "bucket-prod-01032025"
    key            = "terraform.tfstate"
    dynamodb_table = "dynamodb-state-locking"
  }
}
