## Streams list - API endpoint

### Navigation
[README](../../../../README.md)
<
[API reference](../../../api_reference.md)

### HTTP method
GET

### API endpoint
`/api/v1/streams`

### Request body
```
{
  "page": 1                                                                     (integer, required)
  "is_private": true(MyStreams), null(All streams)                              (boolean, optional)
}
```

### Response
#### Success
```
HTTP code 200 :ok
{
  "streams: "[Stream]"                                                          (array of objects, required)
}
```

### References
- [Stream JSON object](../../../json_objects/stream.md)
