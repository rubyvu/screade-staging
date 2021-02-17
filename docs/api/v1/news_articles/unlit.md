## Delete Article Lit - API endpoint

### Navigation
[README](../../../../README.md)
<
[API reference](../../../api_reference.md)

### HTTP method
DELETE

### API endpoint
`/api/v1/news_articles/:id/unlit`

### Request body
```
{}
```

### Response
#### Success
```
HTTP code 200 :ok
{
  "success: "true"                                                              (boolean, required)
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
