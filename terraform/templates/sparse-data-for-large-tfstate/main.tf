terraform {
  required_version = ">= 1.1.0"
}

variable "sparse_file_size" {
    default = "1k"
    description = "eg. 2b, 500k, 1m"
    
    validation {
        condition = can(regex("^[0-9]+(b|k|m)$", lower(var.sparse_file_size))) && (
            (can(regex("^[0-9]+b$", lower(var.sparse_file_size))) && tonumber(regex("^([0-9]+)b$", lower(var.sparse_file_size))[0]) <= 104857600) ||
            (can(regex("^[0-9]+k$", lower(var.sparse_file_size))) && tonumber(regex("^([0-9]+)k$", lower(var.sparse_file_size))[0]) <= 102400) ||
            (can(regex("^[0-9]+m$", lower(var.sparse_file_size))) && tonumber(regex("^([0-9]+)m$", lower(var.sparse_file_size))[0]) <= 100)
        )
        error_message = "The sparse_file_size must be in format like '2b', '500k', or '1m' and cannot exceed 100m (104857600b or 102400k)."
    }
}

# variable "sparse_data_multiple_output_count" {
#   default = 1024
#   description = "1024 is max value excepted"
# }

resource "random_pet" "filename_suffix" {
  length = 2
}

locals {
  sparse_file_path = "/tmp/sparse-${random_pet.filename_suffix.id}"
}

resource "null_resource" "generate_sparse_file" {
  triggers = {
    sparse_file_size = var.sparse_file_size
    sparse_file_path = local.sparse_file_path
  }

  provisioner "local-exec" {
    # geenerate sparse file
    command = "dd if=/dev/zero of=${local.sparse_file_path} bs=${var.sparse_file_size} count=1"
  }

  provisioner "local-exec" {
    when    = destroy
    command = "rm -fv ${self.triggers.sparse_file_path} && echo Deleted!"
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
  sensitive = true
}

# output "spare_data_multiple" {
#   value = [for i in range(var.sparse_data_multiple_output_count) : data.local_file.sparse_file.content]
#   sensitive = true
# }

output "spare_filename" {
  value = local.sparse_file_path
}
