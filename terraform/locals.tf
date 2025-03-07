#* Definición de variables locales

#* Cadena que contiene las etiquetas que se le asignaran a cada recurso
locals {
  sufix = "${var.tags.project}-${var.tags.env}-${var.tags.region}"
}
