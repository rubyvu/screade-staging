## Create Chat - API endpoint

### Navigation
[README](../../../../README.md)
<
[API reference](../../../api_reference.md)

### HTTP method
POST

### API endpoint
`/api/v1/chats`

### Request body
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

#### Errors
- when object cannot be created
```
HTTP code 422 :unprocessable_entity
{
  "errors": ['Name cannot be blank.']                                           (array of strings, required)
}
```

### References
- [Chat JSON object](../../../json_objects/chat.md)
