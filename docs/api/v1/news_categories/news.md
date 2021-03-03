## Category News Articles list - API endpoint

### Navigation
[README](../../../../README.md)
<
[API reference](../../../api_reference.md)

### HTTP method
GET

### API endpoint
`/api/v1/news_categories/:id/news`

### Request body
```
{
  "is_national": true                                                           (boolen, optional)
  "page": 1                                                                     (integer, required)
  "location_code": "UA"                                                         (string, required)
}
```

### Response
#### Success
```
HTTP code 200 :ok
{
  "news: "[NewsArticle]"                                                        (array of objects, required)
}
```

#### Errors
- when Category doesn't exists
```
HTTP code 404 :not_found
{
  "errors": ['Record not found.']                                               (array of strings, required)
}
```

### References
- [NewsArticle JSON object](../../../json_objects/news_article.md)
