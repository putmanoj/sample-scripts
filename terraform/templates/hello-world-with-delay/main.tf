terraform {
  required_version = ">= 1.1.0"
}

variable "name" {
    type = string
    default = "World"
}

variable "create_wait" {
    type = string
    default = "30s"
}

variable "destroy_wait" {
    type = string
    default = "30s"
}

resource "time_static" "time_start" {}

resource "time_sleep" "wait" {
  depends_on = [time_static.time_start]

  create_duration = "${var.create_wait}"
  destroy_duration = "${var.destroy_wait}"

  triggers = {
    the_greeting = "Hello ${var.name}"
    create_wait = var.create_wait
    destroy_wait = var.destroy_wait
  }  
}

resource "null_resource" "hello_world" {
  depends_on = [time_sleep.wait]

  triggers = {
    the_greeting = "Hello ${var.name}"
    create_wait = var.create_wait
    destroy_wait = var.destroy_wait
  }

  provisioner "local-exec" {
      command = "echo 'Hello ${var.name}'"
  }
}

resource "time_static" "time_end" {
  depends_on = [null_resource.hello_world]
}

output "time" {
  value = {
    start = time_static.time_start.rfc3339,
    end = time_static.time_end.rfc3339
  }
}

output "greeting" {
  value = null_resource.hello_world.triggers.the_greeting
}
