package global.adam_custom_snippets

#############################################################################
# METADATA: library-snippet/entitlements
# version: v1
# title: "ADAM: Adam's entitlements list"
# description: >-
#   This custom snippet asks the user to enter one parameter, the subjects (aka users).
#   It does not provide any guidance for those values.
# schema:
#   type: object
#   properties:
#     user_attribute:
#       type: string
#     resource_attribute:
#       type: string
#       "hint:items":
#         library: "global/adam_custom_snippets"
#         query: "global.adam_custom_snippets.resource_attributes_array"
#     operation:
#       type: string
#       enum: [">=", ">", "=", "<", "<="]
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
#     value: "obj := {{library-snippet}}"
#   schema:
#     decision:
#       type: object
#       properties:
#         message:
#           type: rego
#           value: "obj.message"
#         entz:
#            type: rego
#            value: "obj.entz"
#       required:
#         - message
#         - entz
#############################################################################
adam_entitlements_list = obj {
	obj := {
	    "allowed": count(entitlements) > 0,
	    "message": "List of entitlements the user has based on attributes",
	    "entz": {
	        "resources": entitlements,
	        "snippet": "custom_snippets/adam_entitlements_list"
	    }
	}
}

entitlements[resource] {
  data.library.parameters.operation == ">="
  data.object.users[input.subject][data.library.parameters.user_attribute] >=
    data.object.resources[resource][data.library.parameters.resource_attribute]
}

entitlements[resource] {
  data.library.parameters.operation == ">"
  data.object.users[input.subject][data.library.parameters.user_attribute] >
    data.object.resources[resource][data.library.parameters.resource_attribute]
}

entitlements[resource] {
  data.library.parameters.operation == "="
  data.object.users[input.subject][data.library.parameters.user_attribute] ==
    data.object.resources[resource][data.library.parameters.resource_attribute]
}

entitlements[resource] {
  data.library.parameters.operation == "<"
  data.object.users[input.subject][data.library.parameters.user_attribute] <
    data.object.resources[resource][data.library.parameters.resource_attribute]
}

entitlements[resource] {
  data.library.parameters.operation == "<="
  data.object.users[input.subject][data.library.parameters.user_attribute] <=
    data.object.resources[resource][data.library.parameters.resource_attribute]
}

resource_attributes[a] {
    data.object.resources[_][a]
}

resource_attributes_array = a {
    a := [ a | a := resource_attributes[_] ]
}