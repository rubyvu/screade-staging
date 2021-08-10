## Stream JSON object

### Navigation
[README](../../README.md)
<
[API reference](../api_reference.md)

### Object structure
```
{
  "access_token": "d2p3bm3l42ldk123dsa"                                         (string, required)
  "channel_id": "3123123"                                                       (string, optional)
  "channel_input_id": "4234234"                                                 (string, optional)
  "channel_security_group_id": "23423423"                                       (string, optional)
  "created_at": "2021-02-04 14:22:14 +0000",                                    (string, required)
  "error_message": "Input attachments should be present."                       (string, optional)
  "group_id": "1"                                                               (string, optional)
  "group_type": "Topic"                                                         (string, optional)
  "is_private": "true"                                                          (boolean, optional)
  "image": "https://image.jpg"                                                  (string, optional)
  "status": "pending", "in-progress", "completed", "finished", "failed"         (string, required)
  "stream_url": "https://video-stream-url"                                      (string, optional)
  "rtmp_url": "rtmp://localhost/screade-live/stream"                            (string, optional)
  "title": "New stream"                                                         (string, required)
  "user": User                                                                  (object, required)
  "video": "https://video..m3u8"                                                (string, optional)
}
```
