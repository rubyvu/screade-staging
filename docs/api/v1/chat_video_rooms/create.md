## Create Chat Video Room - API endpoint

### Navigation
[README](../../../../README.md)
<
[API reference](../../../api_reference.md)

### HTTP method
POST

### API endpoint
`/chats/:chat_access_token/chat_video_rooms`

```
{}
```

### Response
#### Success
```
HTTP code 200 :ok
{
  "chat_video_room": "ChatVideoRoom"                                            (object, required)
  "chat_video_room_user_token": "dk3oxn35cjkf84n39m39"                          (string, required)
}
```

#### Errors
- when existing room is full(>= than 50 participants)
```
HTTP code 422 :unprocessable_entity
{
  "errors": ['Maximum 50 participants per room.']                               (array of strings, required)
}
```

- when access token can not be generated
```
HTTP code 422 :unprocessable_entity
{
  "errors": ['Twilio user token can not be generated, try again later.']        (array of strings, required)
}
```

### References
- [ChatVideoRoom JSON object](../../../json_objects/chat_video_room.md)
