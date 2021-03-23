## Get user Squad Requests - API endpoint

### Navigation
[README](../../../../README.md)
<
[API reference](../../../api_reference.md)

### HTTP method
GET

### API endpoint
`/api/v1/squad_requests`

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
  "squad_requests": "[SquadRequest]"                                            (array of objects, required)
}
```

### References
- [Squad Request JSON object](../../../json_objects/squad_request.md)
