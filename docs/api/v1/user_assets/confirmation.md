## Confirm image upload - API endpoint

### Navigation
[README](../../../../README.md)
<
[API reference](../../../api_reference.md)

### HTTP method
POST

### API endpoint
`/api/v1/user_assets/confirmation`

### Request body
```
{
  "confirmation": {
    "key": "upload/dh6g-fdgh5h-45fg/test.png"                                   (string, required)
    "uploader_id: "1"                                                           (integer, required)
  }
}
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
- when Key doesn't exists
```
HTTP code 400 :bad_request
{
  "errors": ['Key should be present.']                                          (array of strings, required)
}
```

- when Key doesn't valid
```
HTTP code 400 :bad_request
{
  "errors": ['Wrong key format.']                                               (array of strings, required)
}
```

- when UserImage or UserVideo cannot be created
```
HTTP code 422 :unprocessable_entity
{
  "errors": ['File cannot be blank.']                                           (array of strings, required)
}
```
