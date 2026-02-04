terraform {
  required_version = ">= 1.1.0"
}

locals {
  name = "World"
}

resource "null_resource" "null_resource_simple" {
    triggers = {
      the_greeting = "Hello ${local.name}"
    }  
    provisioner "local-exec" {
        command = "echo 'Hello ${local.name}'"
    }
}

output "greeting" {
  value = null_resource.null_resource_simple.triggers.the_greeting
}
