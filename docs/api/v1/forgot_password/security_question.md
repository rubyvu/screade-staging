## Get security question fo User - API endpoint

### Navigation
[README](../../../../README.md)
<
[API reference](../../../api_reference.md)

### HTTP method
GET

### API endpoint
`/api/v1/forgot_password/security_question`

### Params
```
{
  "email": "example@gmail.com"                                                  (string, required)
}
```

### Response
#### Success
```
HTTP code 200 :ok
{
  "security_question": "UserSecurityQuestion"                                   (object, required)
}
```

#### Errors
- when User have no security question or User not found
```
HTTP code 404 :not_found
{
  "errors": ['Record not found.']                                               (array of strings, required)
}
```

### References
- [UserSecurityQuestion JSON object](../../../json_objects/user_security_question.md)
