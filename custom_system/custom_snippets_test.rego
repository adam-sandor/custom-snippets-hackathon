package global.custom_snippets

test_allow {
    result := allow with input as {
        "user": "janet",
        "path": "/home",
        "method": "GET"
    }
    with data.groups as {
        "back-office": {
          "users": [
            "janet",
            "william"
          ]
        },
        "store-managers": {
          "users": [
            "alice"
          ]
        }
    }
    with data.library.parameters as {
        "group": "back-office",
        "method": "GET",
        "path": "/home"
    }

    print(result)
    result == {"User janet granted access to perform GET on path '/home' based on membership of group back-office"}
}

test_deny_not_member {
    result := allow with input as {
        "user": "janet",
        "path": "/home",
        "method": "GET"
    }
    with data.groups as {
        "back-office": {
          "users": [
            "william"
          ]
        },
        "store-managers": {
          "users": [
            "janet"
          ]
        }
    }
    with data.library.parameters as {
        "group": "back-office",
        "method": "GET",
        "path": "/home"
    }

    print(result)
    result == set()
}