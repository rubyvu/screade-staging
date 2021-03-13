## User Videos - API endpoint

### Navigation
[README](../../../../README.md)
<
[API reference](../../../api_reference.md)

### HTTP method
GET

### API endpoint
`/api/v1/user_assets/:username/videos`

### Request body
```
{
  "page": "1"                                                                   (integer, required)
}
```

### Response
#### Success
```
HTTP code 200 :ok
{
  "videos: "[UserVideo]"                                                        (array of objects, required)
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
- [UserVideo JSON object](../../../json_objects/user_video.md)
