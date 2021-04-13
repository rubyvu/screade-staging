## Update User Image - API endpoint

### Navigation
[README](../../../../README.md)
<
[API reference](../../../api_reference.md)

### HTTP method
PUT/PATCH

### API endpoint
`/api/v1/user_images/:id`

```
{
  "user_image": {
    "is_private": true                                                          (boolean, optional)
  }
}
```

### Response
#### Success
```
HTTP code 200 :ok
{
  "user_image": "UserImage"                                                     (object, required)
}
```

#### Errors
- when object params is not valid
```
HTTP code 422 ::unprocessable_entity
{
  "errors": ['Is private can't be blank']                                       (array of strings, required)
}
```

### References
- [UserImage JSON object](../../../json_objects/user_image.md)
