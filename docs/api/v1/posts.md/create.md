## Create Post - API endpoint

### Navigation
[README](../../../../README.md)
<
[API reference](../../../api_reference.md)

### HTTP method
POST

### API endpoint
`/api/v1/posts`

### Request body
```
{
  "post": {
    "image": Image file                                                         (multipart/form-data, required)
    "title": 'New title description'                                            (string, required)
    "description": 'New post description'                                       (string, required)
    "news_category_id": 1                                                       (integer, required)
    "topic_id": 1                                                               (integer, required)
  }
}
```

### Response
#### Success
```
HTTP code 200 :ok
{
  "post: Post                                                                   (object, required)
}
```

#### Errors
- when object cannot be created
```
HTTP code 422 :unprocessable_entity
{
  "errors": ['Title cannot be blank.']                                          (array of strings, required)
}
```

### References
- [Post JSON object](../../../json_objects/post.md)
