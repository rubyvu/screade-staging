## Post Comments list by date - API endpoint

### Navigation
[README](../../../../README.md)
<
[API reference](../../../api_reference.md)

### HTTP method
GET

### API endpoint
`GET /api/v1/posts/:posts_id/post_comments`

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
  "comments: "[Comment]"                                                        (array of objects, required)
}
```

### References
- [Comment Comment JSON object](../../../json_objects/comment.md)
