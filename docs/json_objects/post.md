## Post JSON object

### Navigation
[README](../../README.md)
<
[API reference](../api_reference.md)

### Object structure
```
{
  "comments_count": "1"                                                         (integer, required)
  "description": 'Description string'                                           (string, required)
  "id": 1                                                                       (integer, required)
  "image": 'https://...'                                                        (string, optional)
  "is_notification": true                                                       (boolean, required)
  "is_commented": "false"                                                       (boolean, required)
  "is_lited": "false"                                                           (boolean, required)
  "is_viewed": "true"                                                           (boolean, required)
  "lits_count": "1"                                                             (integer, required)
  "source": NewsCategory || Topic                                               (object, required)
  "state": 'pending | approved'                                                 (string, required)
  "title": 'Post title'                                                         (string, required)
  "views_count": 1                                                              (integer, required)
  "user": UserProfile                                                           (object, required)
}
```

### References
- [UserProfile JSON object](./user_profile.md)
- [Topic JSON object](./topic.md)
- [NewsCategory JSON object](./news_category.md)
