## ChatMessage JSON object

### Navigation
[README](../../README.md)
<
[API reference](../api_reference.md)

### Object structure
```
{
  "created_at": "2021-02-04 14:22:14 +0000",                                    (string, required, represents date in format "%Y-%m-%d %H:%M:%S %z")
  "message_type": 'text' || 'audio' || 'video' || 'image' || 'video-room' || 'audio-room'           (string, required)
  "message_content": "http://site.com/small.png"                                (string or object, optional)
  "id": "1"                                                                     (integer, required)
  "user": "User"                                                                (object, required)
}
```

### References
- [UserProfile JSON object](./user_profile.md)
- [ChatVideoRoom JSON object](./chat_video_room.md)
