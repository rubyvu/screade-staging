## Update current user - API endpoint

### Navigation
[README](../../../../README.md)
<
[API reference](../../../api_reference.md)

### HTTP method
PUT/PATCH

### API endpoint
`/api/v1/current_user`

### Request body
```
{
  "user": {
    "banner_picture": "http://site.com/small.png",                              (string, optional)
    "birthday": "2018-05-23",                                                   (string, optional, represents date in format "%Y-%m-%d")
    "country_code": "UA"                                                        (string, required)
    "email": "example@gmail.com"                                                (string, required)
    "first_name": "John",                                                       (string, optional)
    "last_name": "Doe",                                                         (string, optional)
    "middle_name": "Michael",                                                   (string, optional)
    "phone_number": "506988478",                                                (string, optional)
    "profile_picture": "http://site.com/small.png",                             (string, optional)
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
  "user": "UserObject"                                                          (object, required)
}
```

#### Errors
- when User params is not valid
```
HTTP code 422 ::unprocessable_entity
{
  "errors": ['Email can't be blank']                                            (array of strings, required)
}
```

### References
- [User JSON object](../../../json_objects/user.md)
