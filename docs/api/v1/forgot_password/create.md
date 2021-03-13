## Forgot password - API endpoint

### Navigation
[README](../../../../README.md)
<
[API reference](../../../api_reference.md)

### HTTP method
POST

### API endpoint
`/api/v1/forgot_password`

### Request body
```
{
  "user": {
    "email": "example@gmail.com"                                                (string, required)
  },
  "security_question": {
    "question_identifier": "q_1"                                                (string, required)
    "security_question_answer": "Answer example"                                (string, required)
  }
}
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
- when User with question_identifier and security_question_answer do not exists
```
HTTP code 404 :not_found
{
  "errors": ['Record not found.']                                               (array of strings, required)
}
```

- when User reach limit of incorrect answers attempts
```
HTTP code 403 :forbidden
{
  "errors": ['You have reached the limit of incorrect answers, your profile has been blocked.']     (array of strings, required)
}
```
