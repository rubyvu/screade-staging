## News list - API endpoint

### Navigation
[README](../../../../README.md)
<
[API reference](../../../api_reference.md)

### HTTP method
GET

### API endpoint
`/api/v1/home/news`

### Request body
```
{
  "is_national": true                                                           (boolen, optional)
  "page": 1                                                                     (integer, required)
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

### References
- [NewsArticle JSON object](../../../json_objects/news_article.md)
