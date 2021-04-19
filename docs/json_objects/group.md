## Group JSON object

### Navigation
[README](../../README.md)
<
[API reference](../api_reference.md)

### Object structure
```
{
  "type": "NewsCategory || Topic"                                               (string, required)
  "id": 20                                                                      (integer, required)
  "title": "Technology"                                                         (string, required)
  "image": "https://icon.com"                                                   (string, optional)
  "is_subscription": false                                                      (boolean, required)
  "subscriptions_count": 0                                                      (integer, optional)
  "parent_type": "NewsCategory || Topic"                                        (string, optional)
  "parent_id": 1                                                                (integer, optional)
}
```
