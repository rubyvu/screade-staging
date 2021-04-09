## UserProfile JSON object

### Navigation
[README](../../README.md)
<
[API reference](../api_reference.md)

### Object structure
```
{
  "banner_picture": "http://site.com/small.png",                                (string, optional)
  "comments_count": "1",                                                        (integer, required)
  "email": "example@gmail.com",                                                 (string, required)
  "first_name": "John",                                                         (string, optional)
  "font_family": "roboto",                                                      (string, required)
  "font_style": "normal",                                                       (string, required)
  "is_images": "true",                                                          (boolean, required)
  "is_videos": "true",                                                          (boolean, required)
  "is_posts": "true",                                                           (boolean, required)
  "last_name": "Doe",                                                           (string, optional)
  "lits_count": "0",                                                            (integer, required)
  "middle_name": "Michael",                                                     (string, optional)
  "profile_picture": "http://site.com/small.png",                               (string, optional)
  "squad_request_state": 'request_confirmed||request_sent||none'                (string, required)
  "squad_request_id": 1                                                         (integer, optional)
  "views_count": "2"                                                            (integer, required)
  "username": "john"                                                            (string, required)
}
```
