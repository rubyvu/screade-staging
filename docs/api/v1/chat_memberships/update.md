## Update Chat Membership - API endpoint

### Navigation
[README](../../../../README.md)
<
[API reference](../../../api_reference.md)

### HTTP method
PUT/PATCH

### API endpoint
`/api/v1/chat_memberships/:id`

```
{
  "chat_membership": {
    "role": "owner" || "admin" | "user"                                         (string, required)
  }
}
```

### Response
#### Success
```
HTTP code 200 :ok
{
  "chat_membership": "ChatMembership"                                           (object, required)
}
```

#### Errors
- when object cannot be updated
```
HTTP code 422 :unprocessable_entity
{
  "errors": ['Role cannot be blank.']                                           (array of strings, required)
}
```

### References
- [ChatMembership JSON object](../../../json_objects/chat_membership.md)
