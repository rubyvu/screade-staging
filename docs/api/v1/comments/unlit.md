## Delete Comment Lit - API endpoint

### Navigation
[README](../../../../README.md)
<
[API reference](../../../api_reference.md)

### HTTP method
DELETE

### API endpoint
`/api/v1/comments/:id/unlit`

### Request body
```
{}
```

### Response
#### Success
```
HTTP code 200 :ok
{
  "comment: "Comment"                                                           (object, required)
}
```

#### Errors
- when Comment doesn't exists
```
HTTP code 404 :not_found
{
  "errors": ['Record not found.']                                               (array of strings, required)
}
```

- when Lit params is not valid
```
HTTP code 422 :unprocessable_entity
{
  "errors": ["Source is required"]                                              (array of strings, required)
}
```

### References
- [User JSON object](../../../json_objects/comment.md)
