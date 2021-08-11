## Create Stream - API endpoint

### Navigation
[README](../../../../README.md)
<
[API reference](../../../api_reference.md)

### HTTP method
POST

### API endpoint
`/api/v1/streams`

### Request body
```
{
  "stream": {
    "group_id": 1                                                               (integer, optional)
    "group_type": "Topic" || "NewsCategory"                                     (string, optional)
    "is_private": true                                                          (boolean, required)
    "title": 'New Stream'                                                       (string, required)
    "usernames": ['one', 'two']                                                 (array, optional)
  }
}
```

### Response
#### Success
```
HTTP code 200 :ok
{
  "stream: Stream                                                               (object, required)
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
