## Topic - API endpoint

### Navigation
[README](../../../../README.md)
<
[API reference](../../../api_reference.md)

### HTTP method
GET

### API endpoint
`/api/v1/topics/:id`

### Request body
```
{}
```

### Response
#### Success
```
HTTP code 200 :ok
{
  "topic: "Topic"                                                               (objects, required)
}
```

#### Errors
- when Topic doesn't exists
```
HTTP code 404 :not_found
{
  "errors": ['Record not found.']                                               (array of strings, required)
}
```

### References
- [Topic JSON object](../../../json_objects/topic.md)
