## Delete Chat Membership - API endpoint

### Navigation
[README](../../../../README.md)
<
[API reference](../../../api_reference.md)

### HTTP method
DELETE

### API endpoint
`/api/v1/chat_memberships/:id`

```
{}
```

### Response
#### Success
```
HTTP code 200 :ok
{
  "success": true                                                               (boolean, required)
}
```

#### Errors
- when object cannot be updated
```
HTTP code 422 :unprocessable_entity
{
  "errors": ['You must assign a new Owner before leaving.']                     (array of strings, required)
}
```
