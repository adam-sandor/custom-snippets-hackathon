package global.adam_custom_snippets

# object_users and object_resources are defined in this way to guarantee they
# will never be undefined, even if data.object.{users,resources} is not
# defined.
object_users = data.object.users {
	true
} else = {} {
	true
}

object_resources = data.object.resources {
	true
} else = {} {
	true
}

#############################################################################
# METADATA: library-snippet/entitlements
# version: v1
# title: "ADAM: Adam's first custom snippet"
# description: >-
#   This custom snippet asks the user to enter one parameter, the subjects (aka users).
#   It does not provide any guidance for those values.
# schema:
#   type: object
#   properties:
#     subjects:
#       type: array
#       items:
#         type: string
#       uniqueItems: true
#   decision:
#     oneOf:
#       - required:
#         - allowed
#       - required:
#         - denied
#     type: object
#     properties:
#       allowed:
#         const: true
#         description: "If true, allows the request."
#         title: "Allow"
#         type: "boolean"
#       denied:
#         const: true
#         description: "If true, denies the request."
#         title: "Deny"
#         type: "boolean"
#       entz:
#         description: "Add elements to the entz set"
#         parameter: false
#         title: "Entitlements"
#         type: "array"
#         uniqueItems: true
#       message:
#         type: string
#         parameter: false
#     required:
#       - attributes
# policy:
#   rule:
#     type: rego
#     value: "{{library-snippet}}[obj]"
#   schema:
#     decision:
#       type: object
#       properties:
#         message:
#           type: rego
#           value: "obj.message"
#       required:
#         - message
#############################################################################
custom_snippet_params[obj] {
	obj := {"message": sprintf("CUSTOM: Hello from Adam (%s)", [data.library.parameters.subjects])}
}

entitlements[resource] {
  data.object.users[input.subject].role == "customer_support"
  data.object.users[input.subject].role_level >= data.object.resources[resource].role_level
}

#############################################################################
# METADATA: library-snippet/entitlements
# version: v1
# title: "ADAN: User has attributes (Copy of ABAC)"
# diagnostics:
#   - entz_object_check_users
#   - subject_exists
#   - subject_has_attributes
# description: >-
#   Matches requests where the user making a request has all of the selected attributes.
# schema:
#   type: object
#   properties:
#     attributes:
#       type: object
#       title: Attributes
#       patternNames:
#         title: "Users attribute key"
#       additionalProperties:
#         type: string
#         title: "Users attribut value"
#   additionalProperties: false
#   required:
#     - attributes
#   decision:
#     oneOf:
#       - required:
#         - allowed
#       - required:
#         - denied
#     type: object
#     properties:
#       allowed:
#         const: true
#         description: "If true, allows the request."
#         title: "Allow"
#         type: "boolean"
#       denied:
#         const: true
#         description: "If true, denies the request."
#         title: "Deny"
#         type: "boolean"
#       entz:
#         description: "Add elements to the entz set"
#         parameter: false
#         title: "Entitlements"
#         type: "array"
#         uniqueItems: true
#       message:
#         type: string
#         parameter: false
#     required:
#       - attributes
# policy:
#   rule:
#     type: rego
#     value: "{{library-snippet}}[obj]"
#   schema:
#     decision:
#       type: object
#       properties:
#         message:
#           type: rego
#           value: "obj.message"
#       required:
#         - message
# policy:
#   rule:
#     type: rego
#     value: "{{library-snippet}}[obj]"
#   schema:
#     decision:
#       type: object
#       properties:
#         entz:
#           type: rego
#           value: "obj.entz"
#         message:
#           type: rego
#           value: "obj.message"
#       required:
#         - entz
#         - message
custom_user_has_attributes[obj] {
	object_has_all_attributes(object_users[input.subject], data.library.parameters.attributes)
	msg := sprintf("User %s has attributes %v", [input.subject, data.library.parameters.attributes])
	entz := {
		"snippet": "custom_snippets/custom_user_has_attributes",
		"type": "attributes",
		"attributes": data.library.parameters.attributes,
	}
	obj := {
		"message": msg,
		"entz": entz,
	}
}