## Comment JSON object

### Navigation
[README](../../README.md)
<
[API reference](../api_reference.md)

### Object structure
```
{
  "id": "1"                                                                     (integer, required)
  "message": "Comment text example"                                             (string, required)
  "comment_id": 1                                                               (integer, optional)
  "created_at": "2021-02-04 14:22:14 +0000",                                    (string, required, represents date in format "%Y-%m-%d %H:%M:%S %z")
  "commentator": "UserProfile"                                                  (object, required)
  "is_lited": "true"                                                            (boolean, required)
  "lits_count": "10"                                                            (integer, required)
  "replied_comments_count": 20                                                  (integer, required)
  "source_title": 'News Article title'                                          (string, required)
  "source_type": 'NewsArticle'                                                  (string, required)
  "source_id": 1                                                                (integer, required)
}
```

### References
- [UserProfile JSON object](./user_profile.md)
