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
  "source_id": 'NewsCategory'                                                   (integer, required)
  "source_type": 'NewsCategory'                                                 (string, required)
  "state": 'pending | approved'                                                 (string, required)
  "title": 'Post title'                                                         (string, required)
  "user": UserProfile                                                           (object, required)
}
```

### References
- [UserProfile JSON object](./user_profile.md)
