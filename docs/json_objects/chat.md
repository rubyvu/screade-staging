## Chat JSON object

### Navigation
[README](../../README.md)
<
[API reference](../api_reference.md)

### Object structure
```
{
  "access_token": "fhjsd93dj340fdpqci2"                                         (string, required)
  "created_at": "fhjsd93dj340fdpqci2"                                           (string, required)
  "icon": "http://site.com/small.png"                                           (string, optional)
  "name": "Chat 1"                                                              (string, optional)
  "owner": "User"                                                               (object, required)
  "chat_memberships": ["ChatMembership"]                                        (array of objects, required)
}
```

### References
- [UserProfile JSON object](./user_profile.md)
- [UserProfile JSON object](./chat_membership.md)
