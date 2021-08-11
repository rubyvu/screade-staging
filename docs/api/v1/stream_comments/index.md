## Stream Comments list by date - API endpoint

### Navigation
[README](../../../../README.md)
<
[API reference](../../../api_reference.md)

### HTTP method
GET

### API endpoint
`GET /api/v1/stream/:stream_access_token/stream_comments`

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
  "stream_comment: [StreamComment]                                              (array of objects, required)
}
```

### References
- [Stream Comment JSON object](../../../json_objects/stream_comment.md)
