## StreamComment JSON object

### Navigation
[README](../../README.md)
<
[API reference](../api_reference.md)

### Object structure
```
{
  "created_at": "2021-02-04 14:22:14 +0000",                                    (string, required, represents date in format "%Y-%m-%d %H:%M:%S %z")
  "message": "Test message"                                                     (string or object, optional)
  "stream_access_token": "ae4k5j3l23mdf34kkf34cln54bo"                          (string, required)
  "id": "1"                                                                     (integer, required)
  "commentator": UserProfile                                                    (object, required)
  "unix_created_at": "3079871278238"                                            (string, required)
}
```

### References
- [UserProfile JSON object](./user_profile.md)
