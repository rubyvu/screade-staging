## News Article - API endpoint

### Navigation
[README](../../../../README.md)
<
[API reference](../../../api_reference.md)

### HTTP method
GET

### API endpoint
`/api/v1/news_articles/:id`

### Request body
```
{}
```

### Response
#### Success
```
HTTP code 200 :ok
{
  "news_article: "NewArticle"                                                   (objects, required)
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
- [NewsArticle JSON object](../../../json_objects/news_article.md)
