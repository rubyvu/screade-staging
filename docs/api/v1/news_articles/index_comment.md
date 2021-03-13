## List of Article Comment - API endpoint

### Navigation
[README](../../../../README.md)
<
[API reference](../../../api_reference.md)

### HTTP method
GET

### API endpoint
`/api/v1/news_articles/:news_article_id/news_article_comments`

### Request body
```
{
  "page": "1"                                                                   (integer, required)
}
```

### Response
#### Success
```
HTTP code 200 :ok
{
  "comments: "[Comment]"                                                        (array of objects, required)
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
