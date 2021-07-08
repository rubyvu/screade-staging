## ChatMembership JSON object

### Navigation
[README](../../README.md)
<
[API reference](../api_reference.md)

### Object structure
```
{
  "id": "1"                                                                     (integer,required)
  "role": "owner" || "admin" || "user"                                          (string, required)
  "owner": "User"                                                               (object, required)
  "unread_messages_count": 1                                                    (integer, required)
}
```

### References
- [UserProfile JSON object](./user_profile.md)
- [Chat JSON object](./chat.md)
