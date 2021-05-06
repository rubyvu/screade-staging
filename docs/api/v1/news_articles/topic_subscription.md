## Create Subscription between News Article and Toppic - API endpoint

### Navigation
[README](../../../../README.md)
<
[API reference](../../../api_reference.md)

### HTTP method
POST

### API endpoint
`/api/v1/news_articles/:id/topic_subscription`

### Request body
```
{
  "news_article_subscription": {
    "topic_id": 1                                                               (integer, required)
  }
}
```

### Response
#### Success
```
HTTP code 200 :ok
{
  "success: true                                                                (boolean, required)
}
```

#### Errors
- when News Article, NewsCategory or Topic doesn't exists
```
HTTP code 404 :not_found
{
  "errors": ['Record not found.']                                               (array of strings, required)
}
```

- when object cannot be created
```
HTTP code 422 :unprocessable_entity
{
  "errors": ['Topic already subscribed.']                                      (array of strings, required)
}
```
