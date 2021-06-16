## Create Chat Message - API endpoint

### Navigation
[README](../../../../README.md)
<
[API reference](../../../api_reference.md)

### HTTP method
POST

### API endpoint
`/api/v1/chats/:chat_access_token/chat_messages`

```
{
  "chat_message": {
    "audio_record": "AudioRecord"                                               (multipart form data, optional)
    "image_id": "1"                                                             (integer, optional)
    "message_type": 'text' || 'audio' || 'video' || 'image'                     (string, required)
    "text": "Chat message"                                                      (string, optional)
    "video_id": "1"                                                             (integer, optional)
  }
}
```

### Response
#### Success
```
HTTP code 200 :ok
{
  "chat_message": "ChatMessage"                                                 (object, required)
}
```

#### Errors
- when object cannot be updated
```
HTTP code 422 :unprocessable_entity
{
  "errors": ['Text cannot be blank.']                                           (array of strings, required)
}
```

### References
- [ChatMessage JSON object](../../../json_objects/chat_message.md)
