## Update current user Settings - API endpoint

### Navigation
[README](../../../../README.md)
<
[API reference](../../../api_reference.md)

### HTTP method
PUT/PATCH

```
{
  "settings": {
    "font_family": "Roboto"                                                     (string, optional)
    "font_style": "normal"                                                      (string, optional)
    "is_notification": "true"                                                   (boolean, optional)
    "is_images": "true"                                                         (boolean, optional)
    "is_videos": "true"                                                         (boolean, optional)
    "is_posts": "true"                                                          (boolean, optional)
  }
}
```

### Response
#### Success
```
HTTP code 200 :ok
{
  "settings": "Settings"                                                        (object, required)
}
```

#### Errors
- when Settings params is not valid
```
HTTP code 422 ::unprocessable_entity
{
  "errors": ['Font style can't be blank']                                       (array of strings, required)
}
```

### References
- [User JSON object](../../../json_objects/settings.md)
