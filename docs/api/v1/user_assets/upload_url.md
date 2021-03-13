## Get Image or Video preassigned url - API endpoint

### Navigation
[README](../../../../README.md)
<
[API reference](../../../api_reference.md)

### HTTP method
GET

### API endpoint
`/api/v1/user_assets/upload_url`

### Request params
```
{
  "filename": "test.png"                                                        (string, required)
}
```

### Response
#### Success
```
HTTP code 200 :ok
{
  "url: "http://s3.example-development"                                         (string, required)
  "key: "upload/dh6g-fdgh5h-45fg/test.png"                                      (string, required)
}
```

#### Errors
- when Filename doesn't exists
```
HTTP code 400 :bad_request
{
  "errors": ['Filename should be present.']                                     (array of strings, required)
}
```

- when preassigned URL cannot be generated
```
HTTP code 422 :unprocessable_entity
{
  "errors": ['Failed to generate image upload url.']                            (array of strings, required)
}
```
