## Create Contact - API endpoint

### Navigation
[README](../../../../README.md)
<
[API reference](../../../api_reference.md)

### HTTP method
POST

### API endpoint
`/api/v1/contacts`

### Request body
```
{
  "contact": {
    "email": 'email@user.com'                                                   (string, required)
    "first_name": 'John'                                                        (string, required)
    "last_name": 'Doe'                                                          (string, required)
    "message": 'New message'                                                    (string, required)
    "subject": 'Subject'                                                        (string, required)
    "username": 'user_1'                                                        (string, required)
  }
}
```

### Response
#### Success
```
HTTP code 200 :ok
{
  "contact: Contact                                                             (object, required)
}
```

#### Errors
- when object cannot be created
```
HTTP code 422 :unprocessable_entity
{
  "errors": ['Email cannot be blank.']                                          (array of strings, required)
}
```

### References
- [Contact JSON object](../../../json_objects/contact.md)
