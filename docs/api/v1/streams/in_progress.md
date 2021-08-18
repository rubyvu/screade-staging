## Update in-progress time for Stream - API endpoint

### Navigation
[README](../../../../README.md)
<
[API reference](../../../api_reference.md)

### HTTP method
PUT/PATCH

### API endpoint
`/api/v1/streams/:access_token/in_progress`

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
- when object state is not 'in-progress'
```
HTTP code 422 :unprocessable_entity
{
  "success": false                                                              (boolean, required)
}
```
