## Chat list - API endpoint

### Navigation
[README](../../../../README.md)
<
[API reference](../../../api_reference.md)

### HTTP method
GET

### API endpoint
`/api/v1/chats`

### Request body
```
{
  "page": "1"                                                                   (integer, required)
}
```

### Response
#### Success
```
HTTP code 200 :ok
{
  "chats: "[ChatObject]"                                                        (array of objects, required)
}
```

### References
- [Chat JSON object](../../../json_objects/chat.md)
