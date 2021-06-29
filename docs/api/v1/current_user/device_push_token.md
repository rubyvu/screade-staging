## Update User Device push token - API endpoint

### Navigation
[README](../../../../README.md)
<
[API reference](../../../api_reference.md)

### HTTP method
PUT

### API endpoint
`/api/v1/current_user/device_push_token`

### Request body
```
{
  'device': {
    'push_token': 'd3k02nv94nd-2mcd94ndf9'                                      (string, required)
  }
}
```

### Response
#### Success
```
HTTP code 200 :ok
{
  "success": true                                                               (boolean, required)
}
```
