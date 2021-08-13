## Stream Comment - API endpoint

### Navigation
[README](../../../../README.md)
<
[API reference](../../../api_reference.md)

### HTTP method
POST

### API endpoint
`/api/v1/streams/:stream_access_token/stream_comments`

### Request body
```
{
  "stream_comment": {
    "message": 'New message example'                                            (string, required)
  }
}
```

### Response
#### Success
```
HTTP code 200 :ok
{
  "stream_comment: StreamComment                                                (objects, required)
}
```

#### Errors
- when Stream doesn't exists
```
HTTP code 404 :not_found
{
  "errors": ['Record not found.']                                               (array of strings, required)
}
```

### References
- [Stream Comment JSON object](../../../json_objects/stream_comment.md)
