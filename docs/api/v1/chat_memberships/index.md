## Chat Membership list - API endpoint

### Navigation
[README](../../../../README.md)
<
[API reference](../../../api_reference.md)

### HTTP method
GET

### API endpoint
`/api/v1/chats/:chat_access_token/chat_memberships`

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
  "chat_memberships: "[ChatMembershipObject]"                                   (array of objects, required)
}
```

### References
- [Chat Membership JSON object](../../../json_objects/chat_membership.md)
