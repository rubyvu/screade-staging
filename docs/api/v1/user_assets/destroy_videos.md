## User Videos destroy - API endpoint

### Navigation
[README](../../../../README.md)
<
[API reference](../../../api_reference.md)

### HTTP method
POST

### API endpoint
`/api/v1/user_assets/destroy_videos`

### Request body
```
{
  "user_video": {
    "ids": [1, 2, 3]                                                            (array of objects)
  }
}
```

### Response
#### Success
```
HTTP code 200 :ok
{
  "success: "true"                                                              (boolean, required)
}
```
