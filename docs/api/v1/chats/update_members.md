## Update Chat Membership - API endpoint

### Navigation
[README](../../../../README.md)
<
[API reference](../../../api_reference.md)

### HTTP method
PUT

### API endpoint
`/api/v1/chats/:access_token/update_members`

```
{
  "chat_membership": {
    "usernames": ['user1', 'user2']                                             (array, required)
  }
}
```

### Response
#### Success
```
HTTP code 200 :ok
{
  "chat: Chat                                                                   (object, required)
}
```

### References
- [Chat JSON object](../../../json_objects/chat.md)
