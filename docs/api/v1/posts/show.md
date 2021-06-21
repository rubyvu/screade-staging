## Post - API endpoint

### Navigation
[README](../../../../README.md)
<
[API reference](../../../api_reference.md)

### HTTP method
GET

### API endpoint
`/api/v1/posts/:id`

### Request body
```
{}
```

### Response
#### Success
```
HTTP code 200 :ok
{
  "post: "Post"                                                                 (objects, required)
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

### References
- [Post JSON object](../../../json_objects/post.md)
