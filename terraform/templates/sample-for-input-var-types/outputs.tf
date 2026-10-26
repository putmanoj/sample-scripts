output "secret" {
  value = var.a_string_with_sensitive_value
  sensitive = true
}

output "my_secret" {
 value = nonsensitive(var.a_string_with_sensitive_value)
}

output "all_values" {
  value = null_resource.null_resource_simple.triggers
}

output "a_string" {
  value = var.a_string
}

output "a_string_required" {
  value = var.a_string_required
}

output "a_string_not_nullable" {
  value = var.a_string_not_nullable
}

output "a_string_with_sensitive_value" {
  value = var.a_string_with_sensitive_value
  sensitive = true
}

output "a_date" {
  value = var.a_date
}

output "a_timestamp_required" {
  value = var.a_timestamp_required
}

output "a_timestamp_now" {
  value = local.a_timestamp_now
}

output "a_number" {
  value = var.a_number
}

output "a_number_required" {
  value = var.a_number_required
}

output "a_bool" {
  value = var.a_bool
}

output "a_bool_required" {
  value = var.a_bool_required
}

output "list_of_strings" {
  value = var.list_of_strings
}

output "list_of_strings_required" {
  value = var.list_of_strings_required
}

output "list_of_any_types" {
  value = var.list_of_any_types
}

output "list_of_any_types_not_nullable" {
  value = var.list_of_any_types_not_nullable
}

output "map_with_string" {
  value = var.map_with_string
}

output "a_object" {
  value = var.a_object
}

output "a_object_with_optional_attribute" {
  value = var.a_object_with_optional_attribute
}

output "list_of_objects" {
  value = var.list_of_objects
}

output "list_of_object_with_nested_structures" {
  value = var.list_of_object_with_nested_structures
}

output "set_of_strings" {
  value = var.set_of_strings
}

output "tuple_of_strings" {
  value = var.tuple_of_strings
}

output "tuple_of_all_primitive_types" {
  value = var.tuple_of_all_primitive_types
}