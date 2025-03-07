#* Definition of local variables

#* String that contains the tags to be assigned to each resource
locals {
  sufix = "${var.tags.project}-${var.tags.env}-${var.tags.region}"
}
