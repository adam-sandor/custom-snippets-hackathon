package global.adam_custom_snippets

test_list_entitlements {
    result := adam_entitlements_list with input as {
        "subject": "adam"
    }
    with data.object as {
        "resources": {
            "resource1": {
                "security_level": 1
            },
            "resource2": {
                "security_level": 2
            },
            "resource3": {
                "security_level": 3
            }
        },
        "users": {
            "adam": {
                "access_level": 2
            }
        }
    }
    with data.library.parameters as {
        "user_attribute": "access_level",
        "operation": ">=",
        "resource_attribute": "security_level"
    }

    print(result)
    result.entz == {
        "snippet": "custom_snippets/adam_entitlements_list",
        "resources": {"resource1", "resource2"}
    }
    result.allowed == true
}

test_list_resource_attributes {
    result := resource_attributes_array with data.object.resources as {
        "resource1": {
            "level": 1
        },
        "resource2": {
            "level": 2
        },
        "resource3": {
            "level": 3
        }
    }

    print(result)
    result == ["level"]
}