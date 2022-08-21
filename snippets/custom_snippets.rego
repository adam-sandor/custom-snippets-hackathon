package global.adam_custom_snippets

#############################################################################
# METADATA: library-snippet/entitlements
# version: v1
# title: "ADAM: User resource access by attribute"
# description: >-
#   List all resources a subject has access to based on a match in attributes. Both the attribute of the user and
#   the attribute of the resource needs to be configured as well as the relationship between them in the form of
#   a math operation. For any operation other than '=' both attributes have to be numbers.
#
#   Example: List all resources where the resource's security_level attribute is lower then or equal 
#   to the subject's access_level attribute.
# schema:
#   type: object
#   properties:
#     user_attribute:
#       type: string
#       title: "User attribute"
#     resource_attribute:
#       type: string
#       title: "Resource attribute"
#     operation:
#       type: string
#       title: Operation
#       description: How to compare the user attribute on the left side to the resource attribute to the right side
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