## Chat Messages list - API endpoint

### Navigation
[README](../../../../README.md)
<
[API reference](../../../api_reference.md)

### HTTP method
GET

### API endpoint
`/api/v1/chats/:chat_access_token/chat_messages`

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
  "chat_messages: "[ChatMessage]"                                               (array of objects, required)
}
```

### References
- [Chat Message JSON object](../../../json_objects/chat_message.md)
