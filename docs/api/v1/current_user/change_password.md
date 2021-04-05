## Change password - API endpoint

### Navigation
[README](../../../../README.md)
<
[API reference](../../../api_reference.md)

### HTTP method
POST

### API endpoint
`/api/v1/current_user/change_password`

### Request body
```
{
  "user": {
    "old_password": '123123123'                                                 (string, required)
    "password": '321321321'                                                     (string, required)
    "old_password": '321321321'                                                 (string, required)
  }
}
```

### Response
#### Success
```
HTTP code 200 :ok
{
  "user": "User"                                                                (object, required)
}
```

#### Errors
- when old_password, password or password_confirmation is empty
```
HTTP code 422 :unprocessable_entity
{
  "errors": ['Password params is empty.']                                       (array of strings, required)
}
```

- when User params is invalid
```
HTTP code 422 :unprocessable_entity
{
  "errors": ['User password cannot be blank.']                                  (array of strings, required)
}
```

### References
- [User JSON object](../../../json_objects/user.md)
