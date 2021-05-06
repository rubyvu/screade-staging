## Create Event - API endpoint

### Navigation
[README](../../../../README.md)
<
[API reference](../../../api_reference.md)

### HTTP method
POST

### API endpoint
`/api/v1/events`

### Request body
```
{
  "event": {
    "date": '2021-02-01'                                                        (string, required, %Y-%m-%d)
    "description": 'New event description'                                      (string, required)
    "end_date": '2021-02-01 12:55:00'                                           (string, required, %Y-%m-%d %H:%M:%S %z)
    "start_date": '2021-02-01 12:50:00'                                         (string, required, %Y-%m-%d %H:%M:%S %z)
    "title": 'New event title'                                                  (string, required)
  }
}
```

### Response
#### Success
```
HTTP code 200 :ok
{
  "event: Event                                                                 (object, required)
}
```

#### Errors
- when object cannot be created
```
HTTP code 422 :unprocessable_entity
{
  "errors": ['Title cannot be blank.']                                          (array of strings, required)
}
```

### References
- [Event JSON object](../../../json_objects/event.md)
