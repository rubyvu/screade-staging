## News Article Comment - API endpoint

### Navigation
[README](../../../../README.md)
<
[API reference](../../../api_reference.md)

### HTTP method
POST

### API endpoint
`/api/v1/news_articles/:news_article_id/news_article_comments`

### Request body
```
{
  "comment": {
    "message": 'New message example'                                            (string, required)
    "comment_id": 1                                                             (string, optional)
  }
}
```

### Response
#### Success
```
HTTP code 200 :ok
{
  "comment: "Comment"                                                           (objects, required)
}
```

#### Errors
- when News Article doesn't exists
```
HTTP code 404 :not_found
{
  "errors": ['Record not found.']                                               (array of strings, required)
}
```

### References
- [Comment JSON object](../../../json_objects/comment.md)
