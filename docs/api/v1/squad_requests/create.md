## Create new Squad Requests - API endpoint

### Navigation
[README](../../../../README.md)
<
[API reference](../../../api_reference.md)

### HTTP method
POST

### API endpoint
`/api/v1/squad_requests/:id/accept`

### Request body
```
{
  "squad_request": {
    receiver_username: "username"                                               (string, required)
  }
}
```

### Response
#### Success
```
HTTP code 200 :ok
{
  "squad_request": "SquadRequest"                                               (object, required)
}
```

#### Errors
- when SquadRequest params is not valid
```
HTTP code 422 ::unprocessable_entity
{
  "errors": ['Requestor can't be blank']                                        (array of strings, required)
}
```

### References
- [Squad Request JSON object](../../../json_objects/squad_request.md)
