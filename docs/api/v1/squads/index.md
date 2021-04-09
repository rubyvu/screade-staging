## Get User Squad by username - API endpoint

### Navigation
[README](../../../../README.md)
<
[API reference](../../../api_reference.md)

### HTTP method
GET

### API endpoint
`/api/v1/user/:username/squads`

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
  "accepted_squad_requests": "[SquadRequest]"                                   (array of objects, required)
}
```

### References
- [Squad Request JSON object](../../../json_objects/squad_request.md)
