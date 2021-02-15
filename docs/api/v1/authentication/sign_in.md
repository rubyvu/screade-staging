## Sign In - API endpoint

### Navigation
[README](../../../../README.md)
<
[API reference](../../../api_reference.md)

### HTTP method
POST

### API endpoint
`/api/v1/authentication/sign_in`

### Request body
```
{
  "user": {
    "email": "example@gmail.com"                                                (string, required)
    "password": "123123123"                                                     (string, required)
  },
  "device": {
    "name": "Device name"                                                       (string, required)
    "operational_system": "iOS"                                                 (string, required)
  }
}
```

### Response
#### Success
```
HTTP code 200 :ok
{
  "access_token": "673bbac7d18c4056382c59f27d0197db"                            (string, required)
  "user": "UserObject"                                                          (object, required)
}
```

#### Errors
- when email params is missing
```
HTTP code 400 :bad_request
{
  "errors": ["Email is required"]                                               (array of strings, required)
}
```

- when password params is missing
```
HTTP code 400 :bad_request
{
  "errors": ["Password is required"]                                            (array of strings, required)
}
```

- when User doesn't exist
```
HTTP code 404 :not_found
{
  errors: ["Record not found"]                                                  (array of strings, required)
}
```

- when Device params is not valid
```
HTTP code 422 :unprocessable_entity
{
  "errors": ["Name is required"]                                                (array of strings, required)
}
```

### References
- [User JSON object](../../../json_objects/user.md)
