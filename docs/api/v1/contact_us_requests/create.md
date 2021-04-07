## Create ContactUsRequest - API endpoint

### Navigation
[README](../../../../README.md)
<
[API reference](../../../api_reference.md)

### HTTP method
POST

### API endpoint
`/api/v1/contact_us_requests`

### Request body
```
{
  "contact_us_request": {
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
  "contact_us_request: ContactUsRequest                                        (object, required)
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
- [ContactUsRequest JSON object](../../../json_objects/contact_us_request.md)
