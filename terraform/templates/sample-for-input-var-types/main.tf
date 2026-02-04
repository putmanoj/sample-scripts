terraform {
  required_version = ">= 1.7.0"
}

variable "a_string" {
  description = "This a string type, with default value"
  type = string
  default = "World"
}

variable "a_string_required" {
  description = "This a string type, value is required, though can have null value"
  type = string
}

variable "a_string_not_nullable" {
  description = "This a string type, cannot have null value, value is required"
  type = string
  nullable = false
}

variable "a_string_with_sensitive_value" {
  description = "This a string type, with sensitive value"
  type = string
  sensitive = true
  default = "The Secret"
}

variable "a_number" {
  description = "This a number type, with default value"
  type	= number
  default = 10
}

variable "a_number_required" {
  description = "This a number type, value is required to provider from user"
  type	= number
}

variable "a_bool" {
  description = "This a boolean type, with default value"
  type	= bool
  default = true
}

variable "a_bool_required" {
  description = "This a boolean type, value is required to provider from user"
  type	= bool
}

variable "list_of_strings" {
  type	= list(string)
  default = ["micro", "large", "xlarge"]
}

variable "list_of_strings_required" {
  description = "This a boolean type, with default value"
  type	= list(string)
}

variable "list_of_any_types" {
  description = "This a list type, value is not required, can have null value"
  type	= list
  default = null
}

variable "list_of_any_types_not_nullable" {
  description = "This a list type, cannot null value, value is required,"
  type	= list(any)
  nullable = false
}

variable "map_with_string" {
  type = map(string)
  default = {
    name      = "demo"
    environment = "dev"
  }
}

variable "a_object" {
  type = object({
    name  = string
    email = string
    age   = number
  })
  default = {
    name  = "Sam"
    email = "sam@example.com"
    age   = 30
  }
}

variable "a_object_with_optional_attribute" {
  type = object({
    user_id = string             # a required attribute
    email = optional(string)     # an optional attribute
    score = optional(number, 1)  # an optional attribute with default value
  })
  default = {
    user_id  = "josh"
  }
}

variable "list_of_objects" {
  type = list(object({
    internal = number
    external = number
    protocol = string
  }))
  default = [
    {
      internal = 8300
      external = 8300
      protocol = "tcp"
    }
  ]
}

variable "list_of_object_with_nested_structures" {
  type = list(object({
    name    = string
    enabled = optional(bool, true)
    website = optional(object({
      index_document = optional(string, "index.html")
      error_document = optional(string, "error.html")
      routing_rules  = optional(string)
    }), {})
  }))
  default = [
    {
      name = "Production",
      "website" = {
        "routing_rules" = <<-EOT
        [
          {
            "Condition" = { "KeyPrefixEquals": "img/" },
            "Redirect"  = { "ReplaceKeyPrefixWith": "images/" }
          }
        ]
        EOT
      }
    },    
    {
      "enabled" = false
      "name" = "archived"
    }
  ]
}

variable "set_of_strings" {
  description = "The set type, holding unordered set of unique values"
  type	= set(string)
  default = ["sg-12345678", "sg-abcdefgh"]
}

variable "tuple_of_strings" {
  description = "The tuple of all string types, which are immutable"
  type	= tuple([string, string])
  default = ["192.168.1.1", "192.168.1.2"]
}

variable "tuple_of_all_primitive_types" {
  description = "The tuple with three different types, which are immutable"
  type	= tuple([string, number, bool])
  default = ["a", 15, true]
}

resource "null_resource" "null_resource_simple" {
  triggers = {
    a_string = var.a_string
    a_string_required =  var.a_string_required
    a_number = var.a_number
    a_number_required = var.a_number_required
    a_bool = var.a_bool
    a_bool_required = var.a_bool_required
    list_of_strings = jsonencode(var.list_of_strings)
    list_of_strings_required = jsonencode(var.list_of_strings_required)
    list_of_any_types = jsonencode(var.list_of_any_types)
    map_with_string = jsonencode(var.map_with_string)
    a_object = jsonencode(var.a_object)
    a_object_with_optional_attribute = jsonencode(var.a_object_with_optional_attribute)
    list_of_objects = jsonencode(var.list_of_objects)
    list_of_object_with_nested_structures = jsonencode(var.list_of_object_with_nested_structures)
    set_of_strings = jsonencode(var.set_of_strings)
    tuple_of_strings = jsonencode(var.tuple_of_strings)
    tuple_of_all_primitive_types = jsonencode(var.tuple_of_all_primitive_types)
  }
}

output "greeting" {
  value = "Hello ${var.a_string}"
}

output "secret" {
  value = var.a_string_with_sensitive_value
  sensitive = true
}

output "my_secret" {
 value = nonsensitive(var.a_string_with_sensitive_value)
}

output "input_values" {
  value = null_resource.null_resource_simple.triggers
}