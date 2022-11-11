package global.custom_snippets

import future.keywords.in

#############################################################################
# METADATA: library-snippet/custom
# version: v1
# title: "Group has access to HTTP resouce"
# description: >-
#   Allow access to an HTTP resource for a certain group
# filePath:
# - systems/.*/policy/.*
# schema:
#   type: object
#   properties:
#     group:
#       type: string
#       title: "Group"
#     method:
#       type: string
#       title: "Method"
#       enum: ["GET", "POST", "PUT", "DELETE", "PATCH", "HEAD", "CONNECT", "OPTIONS", "TRACE", "PATCH"]
#     path:
#       type: string
#       title: "Path"
#   decision:
#     - type: rego
#       key: message
#       value: "msg"
# policy:
#   rule:
#     type: rego
#     value: "{{this}}[msg]"
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
allow[msg] {
	user_in_group(input.user, data.library.parameters.group)
	input.method == data.library.parameters.method
	input.path in [data.library.parameters.path, concat("", ["/", data.library.parameters.path])]

	msg := sprintf("User %s granted access to perform %s on path '%s' based on membership of group %s",
	[input.user, input.method, input.path, data.library.parameters.group])
}

user_in_group(user, group) {
    user in data.groups[group].users
}