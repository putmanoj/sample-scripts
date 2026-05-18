terraform {
  required_version = ">= 1.1.0"
}

variable "sparse_file_size" {
    default = "1k"
}

variable "sparse_file_count" {
    default = "1"
}

variable "spare_data_multiple_count" {
  default = 1024
}

resource "random_pet" "filename_suffix" {
  length = 2
}

locals {
  sparse_file_path = "/tmp/sparse-${random_pet.filename_suffix.id}.txt"
}

resource "null_resource" "generate_sparse_file" {
  triggers = {
    sparse_file_size = var.sparse_file_size
    sparse_file_path = local.sparse_file_path
  }

  provisioner "local-exec" {
    command = "dd if=/dev/zero of=${local.sparse_file_path} bs=${var.sparse_file_size} count=${var.sparse_file_count}"
  }

  provisioner "local-exec" {
    when    = destroy
    command = "rm -v ${self.triggers.sparse_file_path} && echo ${self.triggers.sparse_file_path} deleted"
  }
}

data "local_file" "sparse_file" {
  filename = local.sparse_file_path

  depends_on = [
    null_resource.generate_sparse_file
  ]
}

output "spare_data_once" {
  value = data.local_file.sparse_file.content
}

output "spare_data_multiple" {
  value = [for i in range(var.spare_data_multiple_count) : data.local_file.sparse_file.content]
}

output "spare_filename" {
  value = local.sparse_file_path
}
