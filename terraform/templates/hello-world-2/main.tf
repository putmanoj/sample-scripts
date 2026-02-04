resource "null_resource" "null_resource_simple" {
    triggers = {
      the_greeting = "Hello ${var.name}"
    }    
    provisioner "local-exec" {
        command = "echo Hello '${var.name}'"
    }
}