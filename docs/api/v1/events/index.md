## Events list by date - API endpoint

### Navigation
[README](../../../../README.md)
<
[API reference](../../../api_reference.md)

### HTTP method
GET

### API endpoint
`GET /api/v1/events`

### Request body
```
{
  "date": "2020-02-01"                                                          (string, optional, %Y-%m-%d)
}
```

### Response
#### Success
```
HTTP code 200 :ok
{
  "events: "[Event]"                                                            (array of objects, required)
}
```

### References
- [Event JSON object](../../../json_objects/event.md)
