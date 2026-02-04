terraform {
  required_version = ">= 1.8.0"
}

variable "name" {
    type = string
    default = "HOME"
}

resource "null_resource" "read_env_var_value_via_cli" {
  triggers = { always_run = "${timestamp()}" }
  provisioner "local-exec" {
    command = "printenv ${var.name} > /tmp/v.tmp"
  }
}

data "local_file" "temp_file" {
  depends_on    = [ null_resource.read_env_var_value_via_cli ]
  filename      = "/tmp/v.tmp" 
}

output "name" {
  value = var.name
}

output "value" {
  value = trim(data.local_file.temp_file.content, "\n")
}