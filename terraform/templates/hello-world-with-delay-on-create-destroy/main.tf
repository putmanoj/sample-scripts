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

variable "create_exit_code" {
  type = number
  default = 0
}

variable "destroy_exit_code" {
  type = number
  default = 0
}

resource "time_static" "time_start" {}

resource "time_sleep" "wait" {
  depends_on = [time_static.time_start]

  create_duration = "${var.create_wait}"
  destroy_duration = "${var.destroy_wait}"

  triggers = {
    the_greeting = "Hello ${var.name}"
    name = var.name
    create_wait = var.create_wait
    destroy_wait = var.destroy_wait
    create_exit_code = var.create_exit_code
    destroy_exit_code = var.destroy_exit_code
  }
}

resource "null_resource" "hello_world" {
  depends_on = [time_sleep.wait]

  triggers = {
    the_greeting = "Hello ${var.name}"
    name = var.name
    create_wait = var.create_wait
    destroy_wait = var.destroy_wait    
    create_exit_code = var.create_exit_code
    destroy_exit_code = var.destroy_exit_code
  }

  provisioner "local-exec" {
    command = "echo 'Hello ${var.name} on create'; exit ${var.create_exit_code};"
    when = create
  }

  provisioner "local-exec" {
    command = "echo 'Hello ${self.triggers.name} on destroy'; exit ${self.triggers.destroy_exit_code};"
    when = destroy
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
