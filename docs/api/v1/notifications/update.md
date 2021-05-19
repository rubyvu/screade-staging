## Update Notification - API endpoint

### Navigation
[README](../../../../README.md)
<
[API reference](../../../api_reference.md)

### HTTP method
PUT/PATCH

### API endpoint
`/api/v1/notifications/:id`

```
{
  "notification": {
    "is_viewed": 1                                                              (boolean, optional)
  }
}
```

### Response
#### Success
```
HTTP code 200 :ok
{
  "notification": "Notification"                                                (object, required)
}
```

#### Errors
- when object cannot be created
```
HTTP code 422 :unprocessable_entity
{
  "errors": ['Message cannot be blank.']                                        (array of strings, required)
}
```

### References
- [Notification JSON object](../../../json_objects/notification.md)
