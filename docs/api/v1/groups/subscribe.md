## Create User Subscription for Group - API endpoint

### Navigation
[README](../../../../README.md)
<
[API reference](../../../api_reference.md)

### HTTP method
POST

### API endpoint
`/api/v1/groups/subscribe`

### Request body
```
{
  "user_topic_subscription": {
    "parent_id": 1                                                              (integer, required)
    "parent_type": 'NewsCategory' || 'Topic'                                    (string, required)
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

#### Errors
- when NewsCategory or Topic doesn't exists
```
HTTP code 404 :not_found
{
  "errors": ['Record not found.']                                               (array of strings, required)
}
```

- when source_type is empty
```
HTTP code 422 :unprocessable_entity
{
  "errors": ['Source type should be present.']                                  (array of strings, required)
}
```

- when object cannot be created
```
HTTP code 422 :unprocessable_entity
{
  "errors": ['Source cannot be blank.']                                         (array of strings, required)
}
```
