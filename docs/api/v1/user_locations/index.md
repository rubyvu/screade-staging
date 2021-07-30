## User and User squad members list - API endpoint

### Navigation
[README](../../../../README.md)
<
[API reference](../../../api_reference.md)

### HTTP method
GET

### API endpoint
`/api/v1/user_locations`

### Request body
```
{}
```

### Response
#### Success
```
HTTP code 200 :ok
{
  "current_user_location": 'UserLocation'                                       (object, optional)
  "squad_members_locations: '[UserLocation]'                                    (array of objects, required)
}
```

### References
- [UserLocation JSON object](../../../json_objects/user_location.md)
