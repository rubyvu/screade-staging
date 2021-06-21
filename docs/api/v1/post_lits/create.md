## Lit the Post - API endpoint

### Navigation
[README](../../../../README.md)
<
[API reference](../../../api_reference.md)

### HTTP method
POST

### API endpoint
`/api/v1/posts/:post_id/post_lits`

### Request body
```
{}
```

### Response
#### Success
```
HTTP code 200 :ok
{
  "post: "Post"                                                                 (object, required)
}
```

#### Errors
- when Post doesn't exists
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
- [Post JSON object](../../../json_objects/post.md)
