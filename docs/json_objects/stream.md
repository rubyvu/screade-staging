## Stream JSON object

### Navigation
[README](../../README.md)
<
[API reference](../api_reference.md)

### Object structure
```
{
  "access_token": "d2p3bm3l42ldk123dsa"                                         (string, required)
  "created_at": "2021-02-04 14:22:14 +0000",                                    (string, required)
  "error_message": "Input attachments should be present."                       (string, optional)
  "group_id": "1"                                                               (string, optional)
  "group_type": "Topic"                                                         (string, optional)
  "is_private": "true"                                                          (boolean, optional)
  "is_commented": "false"                                                       (boolean, required)
  "is_lited": "false"                                                           (boolean, required)
  "is_viewed": "true"                                                           (boolean, required)
  "image": "https://image.jpg"                                                  (string, optional)
  "lits_count": "1"                                                             (integer, required)
  "owner": UserProfile                                                          (object, required)
  "playback_url": "https://video-stream-url"                                    (string, optional)
  "status": "in-progress", "completed", "finished", "failed"                    (string, required)
  "stream_comments_count": "1"                                                  (integer, required)
  "rtmp_url": "rtmps://streaming.com"                                           (string, optional)
  "title": "New stream"                                                         (string, required)
  "video": "https://video..m3u8"                                                (string, optional)
  "views_count": 1                                                              (integer, required)
}
```
