## Chat JSON object

### Navigation
[README](../../README.md)
<
[API reference](../api_reference.md)

### Object structure
```
{
  "access_token": "fhjsd93dj340fdpqci2"                                         (string, required)
  "created_at": "2021-02-04 14:22:14 +0000",                                    (string, required, represents date in format "%Y-%m-%d %H:%M:%S %z")
  "icon": "http://site.com/small.png"                                           (string, optional)
  "last_message": ChatMessage                                                   (object, optional)
  "name": "Chat 1"                                                              (string, optional)
  "owner": "User"                                                               (object, required)
  "chat_memberships": ["ChatMembership"]                                        (array of objects, required)
  "update_at": "2021-02-04 14:22:14 +0000",                                     (string, required, represents date in format "%Y-%m-%d %H:%M:%S %z")
}
```

### References
- [UserProfile JSON object](./user_profile.md)
- [ChatMembership JSON object](./chat_membership.md)
- [ChatMessage JSON object](./chat_message.md)
