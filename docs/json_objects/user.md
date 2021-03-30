## User JSON object

### Navigation
[README](../../README.md)
<
[API reference](../api_reference.md)

### Object structure
```
{
  "banner_picture": "http://site.com/small.png",                                (string, optional)
  "birthday": "2018-05-23",                                                     (string, optional)
  "country_code": "UA",                                                         (string, required)
  "comments_count": "1",                                                        (integer, required) represents date in format "%Y-%m-%d")
  "email": "example@gmail.com",                                                 (string, required)
  "first_name": "John",                                                         (string, optional)
  "is_confirmed": "true",                                                       (boolean, required)
  "languages": [Language],                                                      (object, required)
  "last_name": "Doe",                                                           (string, optional)
  "lits_count": "0",                                                            (integer, required)
  "middle_name": "Michael",                                                     (string, optional)
  "phone_number": "506988478",                                                  (string, optional)
  "profile_picture": "http://site.com/small.png",                               (string, optional)
  "views_count": "2"                                                            (integer, required)
  "username": "john"                                                            (string, required)
}
```

### References
- [Language JSON object](../../../json_objects/language.md)
