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
  "news_category": NewsCategory                                                 (object, required)
  "title": 'Post title'                                                         (string, required)
  "topic": Topic                                                                (object, required)
  "state": 'pending | approved'                                                 (string, required)
  "user": UserProfile                                                           (object, required)
}
```

### References
- [NewsCategory JSON object](./news_category.md)
- [Topic JSON object](./topic.md)
- [UserProfile JSON object](./user_profile.md)
