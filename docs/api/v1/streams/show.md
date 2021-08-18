## Stream - API endpoint

### Navigation
[README](../../../../README.md)
<
[API reference](../../../api_reference.md)

### HTTP method
GET

### API endpoint
`/api/v1/streams/:access_token`

### Request body
```
{}
```

### Response
#### Success
```
HTTP code 200 :ok
{
  "stream: Stream                                                               (objects, required)
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
- [Stream JSON object](../../../json_objects/stream.md)
