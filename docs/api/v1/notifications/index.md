## Notifications list - API endpoint

### Navigation
[README](../../../../README.md)
<
[API reference](../../../api_reference.md)

### HTTP method
GET

### API endpoint
`GET /api/v1/notifications`

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
  "posts: "[Notification]"                                                      (array of objects, required)
}
```

### References
- [Notification JSON object](../../../json_objects/notification.md)
