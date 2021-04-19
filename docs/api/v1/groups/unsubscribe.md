## Remove Subscription on Topic or Group - API endpoint

### Navigation
[README](../../../../README.md)
<
[API reference](../../../api_reference.md)

### HTTP method
DELETE

### API endpoint
`/api/v1/groups/unsubscribe`

### Request body
```
{
  "user_topic_subscription": {
    "source_id": 1                                                              (integer, required)
    "source_type": 'NewsCategory' || 'Topic'                                    (string, required)
  }
}
```

### Response
#### Success
```
HTTP code 200 :ok
{
  "success: true                                                                (boolean, required)
}
```
