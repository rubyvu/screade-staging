## Verifications who are called before all API endpoints

### Navigation
[README](../../../README.md)
<
[API reference](../../api_reference.md)

## Check X-Device-Token presence
#### API endpoints where that is skipped
```
  /api/v1/authentication/sign_in
  /api/v1/authentication/sign_up
  /api/v1/countries/ (GET)
  /api/v1/user_security_questions/ (GET)
```

#### Request header
```
{
  "X-Device-Token": "7ffgg334j554o9i"                                           (string, required)
}
```

### Response
#### Errors
- if Device with this token does not exist
```
HTTP code 401 :unauthorized
{
  "errors": ["Device with this token not found."]                               (array of strings, required)
}
```

- if User is locked
```
HTTP code 403 :forbidden
{
  "errors": ["User has been blocked, please contact support."],                 (array of strings, required)
}
```
