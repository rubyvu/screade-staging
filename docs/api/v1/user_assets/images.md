## User Images - API endpoint

### Navigation
[README](../../../../README.md)
<
[API reference](../../../api_reference.md)

### HTTP method
GET

### API endpoint
`/api/v1/user_assets/:username/images`

### Request body
```
{}
```

### Response
#### Success
```
HTTP code 200 :ok
{
  "images: "[UserImage]"                                                        (array of objects, required)
}
```

#### Errors
- when User doesn't exists
```
HTTP code 404 :not_found
{
  "errors": ['Record not found.']                                               (array of strings, required)
}
```

### References
- [UserImage JSON object](../../../json_objects/user_image.md)
