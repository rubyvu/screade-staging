## Resend email confirmation for current user - API endpoint

### Navigation
[README](../../../../README.md)
<
[API reference](../../../api_reference.md)

### HTTP method
POST

### API endpoint
`/api/v1/current_user/resend_email_confirmation`

### Request body
```
{}
```

### Response
#### Success
```
HTTP code 200 :ok
{
  "success": "true"                                                             (boolean, required)
}
```

#### Errors
- when User email already confirmed
```
HTTP code 422 ::unprocessable_entity
{
  "errors": ['User email has been already confirmed.']                                             (array of strings, required)
}
```
