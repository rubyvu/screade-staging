## Post JSON object

### Navigation
[README](../../README.md)
<
[API reference](../api_reference.md)

### Object structure
```
{
  "description": 'Description string'                                           (string, required)
  "id": 1                                                                       (integer, required)
  "image": 'https://...'                                                        (string, optional)
  "is_notification": true                                                       (boolean, required)
  "source": NewsCategory || Topic                                               (object, required)
  "state": 'pending | approved'                                                 (string, required)
  "title": 'Post title'                                                         (string, required)
  "user": UserProfile                                                           (object, required)
}
```

### References
- [UserProfile JSON object](./user_profile.md)
- [Topic JSON object](./topic.md)
- [NewsCategory JSON object](./news_category.md)
