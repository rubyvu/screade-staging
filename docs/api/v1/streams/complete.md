## Complete Stream - API endpoint

### Navigation
[README](../../../../README.md)
<
[API reference](../../../api_reference.md)

### HTTP method
PUT/PATCH

### API endpoint
`/api/v1/streams/:access_token/complete`

```
{}
```

### Response
#### Success
```
HTTP code 200 :ok
{
  "stream": Stream                                                              (object, required)
}
```

#### Errors
- when object cannot be created
```
HTTP code 422 :unprocessable_entity
{
  "errors": ['Title cannot be blank.']                                          (array of strings, required)
}
```

### References
- [Stream JSON object](../../../json_objects/stream.md)
