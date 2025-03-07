#* Definición de Data Sources

#* Obtener el par de claves (key pair) con el nombre "mykey"
data "aws_key_pair" "key" {
  key_name = "mykey"
}
