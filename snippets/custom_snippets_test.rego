package global.adam_custom_snippets

test_list_entitlements {
    result := adam_entitlements_list with input as {
        "subject": "adam"
    }
    with data.object as {
        "resources": {
            "resource1": {
                "role_level": 1
            },
            "resource2": {
                "role_level": 2
            },
            "resource3": {
                "role_level": 3
            }
        },
        "users": {
            "adam": {
                "role": "customer_support",
                "role_level": 2
            }
        }
    }

    print(result)
    result.entz == {"resource1", "resource2"}
    result.allowed == true
}