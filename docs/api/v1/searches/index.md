## Top 5 Searches list - API endpoint

### Navigation
[README](../../../../README.md)
<
[API reference](../../../api_reference.md)

### HTTP method
GET

### API endpoint
`GET /api/v1/searches`

### Request body
```
{
  "search_input": 'Search word'                                                 (string, required, min 3 symbols)
}
```

### Response
#### Success
```
HTTP code 200 :ok
{
  "users: [User]                                                                (array of objects, required)
  "news_articles: [NewsArticle]                                                 (array of objects, required)
  "posts: [Post]                                                                (array of objects, required)
  "groups: [Group]                                                              (array of objects, required)
}
```

### References
- [User JSON object](../../../json_objects/user.md)
- [NewsArticle JSON object](../../../json_objects/news_article.md)
- [Post JSON object](../../../json_objects/post.md)
- [Group JSON object](../../../json_objects/group.md)
