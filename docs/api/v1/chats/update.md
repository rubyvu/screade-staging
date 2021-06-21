## Update Chat - API endpoint

### Navigation
[README](../../../../README.md)
<
[API reference](../../../api_reference.md)

### HTTP method
PUT/PATCH

### API endpoint
`/api/v1/chats/:access_token`

```
{
  "chat": {
    "icon": 'icon'                                                              (multipart form data, optional)
    "name": 'New chat name'                                                     (string, optional)
  }
}
```

### Response
#### Success
```
HTTP code 200 :ok
{
  "chat": "Chat"                                                                (object, required)
}
```

#### Errors
- when object cannot be created
```
HTTP code 422 :unprocessable_entity
{
  "errors": ['Name cannot be blank.']                                          (array of strings, required)
}
```

### References
- [Chat JSON object](../../../json_objects/chat.md)
