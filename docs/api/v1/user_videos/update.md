## Update User Video - API endpoint

### Navigation
[README](../../../../README.md)
<
[API reference](../../../api_reference.md)

### HTTP method
PUT/PATCH

### API endpoint
`/api/v1/user_videos/:id`

```
{
  "user_video": {
    "is_private": true                                                          (boolean, optional)
  }
}
```

### Response
#### Success
```
HTTP code 200 :ok
{
  "user_video": "UserVideo"                                                     (object, required)
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
- [UserVideo JSON object](../../../json_objects/user_video.md)
