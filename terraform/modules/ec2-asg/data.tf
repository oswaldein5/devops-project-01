# Definition of Data Sources

# Get the key pair with the name "mykey"
data "aws_key_pair" "key" {
  key_name = "mykey"
}
