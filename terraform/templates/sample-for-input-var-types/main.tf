terraform {
  required_version = ">= 1.7.0"
}

resource "null_resource" "null_resource_all_values" {
  triggers = {
    a_string                                   = var.a_string
    a_string_required                          = var.a_string_required
    a_string_not_nullable                      = var.a_string_not_nullable
    a_string_with_sensitive_value_nonsensitive = nonsensitive(var.a_string_with_sensitive_value)
    a_date                                     = var.a_date
    a_timestamp_required                       = var.a_timestamp_required
    a_number                                   = var.a_number
    a_number_required                          = var.a_number_required
    a_bool                                     = var.a_bool
    a_bool_required                            = var.a_bool_required
    list_of_strings                            = jsonencode(var.list_of_strings)
    list_of_strings_required                   = jsonencode(var.list_of_strings_required)
    list_of_any_types                          = jsonencode(var.list_of_any_types)
    map_with_string                            = jsonencode(var.map_with_string)
    a_object                                   = jsonencode(var.a_object)
    a_object_with_optional_attribute           = jsonencode(var.a_object_with_optional_attribute)
    list_of_objects                            = jsonencode(var.list_of_objects)
    list_of_object_with_nested_structures      = jsonencode(var.list_of_object_with_nested_structures)
    set_of_strings                             = jsonencode(var.set_of_strings)
    tuple_of_strings                           = jsonencode(var.tuple_of_strings)
    tuple_of_all_primitive_types               = jsonencode(var.tuple_of_all_primitive_types)
  }
}
