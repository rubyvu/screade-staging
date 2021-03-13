## Sign Up - API endpoint

### Navigation
[README](../../../../README.md)
<
[API reference](../../../api_reference.md)

### HTTP method
POST

### API endpoint
`/api/v1/authentication/sign_up`

### Request body
```
{
  "user": {
    "email": "example@gmail.com"                                                (string, required)
    "password": "123123123"                                                     (string, required)
    "password_confirmation": "123123123"                                        (string, required)
    "country_code": "UA"                                                        (string, required)
    "security_question_answer": "John"                                          (string, required)
    "username": "jhon123"                                                       (string, required)  
    "user_security_question_identifier": "q_1"                                  (string, required)
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
  "user": "UserObject"                                                          (string, required)
}
```

#### Errors
- when Country or UserSecurityQuestion doesn't exist
```
HTTP code 404 :not_found
{
  errors: ["Record not found"]                                                  (array of strings, required)
}
```

- when User params is not valid
```
HTTP code 422 ::unprocessable_entity
{
  "errors": [{"email": "can't be blank"}]                                       (array of hashes, required)
}
```

- when Devise params is not valid
```
HTTP code 422 ::unprocessable_entity
{
  "errors": ['Error message']                                                   (array of arrays, required)
}
```

### References
- [User JSON object](../../../json_objects/user.md)
