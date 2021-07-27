## Create or Update User location - API endpoint

### Navigation
[README](../../../../README.md)
<
[API reference](../../../api_reference.md)

### HTTP method
POST

### API endpoint
`/api/v1/user_locations`

### Request body
```
{
  "user_locations": {
    latitude: "34.010203"                                                       (decimal, required)
    longitude: "56.093941"                                                      (decimal, required)
  }
}
```

### Response
#### Success
```
HTTP code 200 :ok
{
  "user_location": "UserLocation"                                               (object, required)
}
```

#### Errors
- when UserLocation params is not valid
```
HTTP code 422 ::unprocessable_entity
{
  "errors": ['Latitude can't be blank']                                        (array of strings, required)
}
```

### References
- [UserLocation JSON object](../../../json_objects/user_location.md)
