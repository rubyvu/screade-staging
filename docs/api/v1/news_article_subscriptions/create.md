## Create Subscription for News Article to Group or Toppic - API endpoint

### Navigation
[README](../../../../README.md)
<
[API reference](../../../api_reference.md)

### HTTP method
POST

### API endpoint
`/api/v1/news_articles/:news_article_id/news_article_subscriptions`

### Request body
```
{
  "news_article_subscription": {
    "source_id": 1                                                              (integer, required)
    "source_type": 'NewsCategory' || 'Topic'                                    (string, required)
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

- when source_type is empty
```
HTTP code 422 :unprocessable_entity
{
  "errors": ['Source type should be present.']                                  (array of strings, required)
}
```

- when object cannot be created
```
HTTP code 422 :unprocessable_entity
{
  "errors": ['Source cannot be blank.']                                         (array of strings, required)
}
```
