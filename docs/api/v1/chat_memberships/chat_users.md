## Chat Users list - API endpoint

### Navigation
[README](../../../../README.md)
<
[API reference](../../../api_reference.md)

### HTTP method
GET

### API endpoint
`/api/v1/chats/:chat_access_token/chat_memberships/chat_users`

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
  "chat_users: "[UserProfile]"                                                  (array of objects, required)
}
```

### References
- [User Profile JSON object](../../../json_objects/user_profile.md)
