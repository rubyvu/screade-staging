## Notification JSON object

### Navigation
[README](../../README.md)
<
[API reference](../api_reference.md)

### Object structure
```
{
  "created_at": "2021-02-04 14:22:14 +0000",                                    (string, required, represents date in format "%Y-%m-%d %H:%M:%S %z")
  "id" : "1"                                                                    (integer, required)
  "is_viewed": "false"                                                          (boolean, required)
  "message": "Notification message"                                             (string, required)
  "source": Comment || Event || Post || UserImage || UserVideo || SquadRequest  (object, required)
  "source_type": Comment || Event || Post || UserImage || UserVideo || ...      (string, required)
  "user": UserProfile                                                           (object, optional)
}
```

### References
- [Comment JSON object](./comment.md)
- [Event JSON object](./event.md)
- [Post JSON object](./post.md)
- [UserImage JSON object](./user_image.md)
- [UserVideo JSON object](./user_video.md)
- [SquadRequest JSON object](./squad_request.md)
- [UserProfile JSON object](./user_profile.md)
