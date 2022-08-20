package global.adam_custom_snippets

test_list_entitlements {
    result := adam_entitlements_list with input as {
        "subject": "adam"
    }
    with data.object as {
        "resources": {
            "resource1": {
                "level": 1
            },
            "resource2": {
                "level": 2
            },
            "resource3": {
                "level": 3
            }
        },
        "users": {
            "adam": {
                "role": "customer_support",
                "role_level": 2
            }
        }
    }
    with data.library.parameters as {
        "user_attribute": "role_level",
        "resource_attribute": "level",
        "operation": ">="
    }

    print(result)
    result.entz == {"resource1", "resource2"}
    result.allowed == true
}