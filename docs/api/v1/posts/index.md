## Posts list by date - API endpoint

### Navigation
[README](../../../../README.md)
<
[API reference](../../../api_reference.md)

### HTTP method
GET

### API endpoint
`GET /api/v1/posts`

### Request body
```
{
  "page": 1                                                                     (integer, required)
}
```

### Response
#### Success
```
HTTP code 200 :ok
{
  "posts: "[Post]"                                                              (array of objects, required)
}
```

### References
- [Post JSON object](../../../json_objects/post.md)
