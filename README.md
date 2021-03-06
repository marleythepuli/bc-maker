# Test Data Maker
Create test data on any service all through a JSON file!

## Installation
```
$ git clone https://github.com/npadilla/bc-maker.git
$ bundle install
```

## How to use it? 
See a list of all the commands
```
$ ./bin/maker
Commands:
  maker create --what=WHAT --where=WHERE          # Create users in Auth, brands in BC ...
  maker delete --id=ID --what=WHAT --where=WHERE  # Delete a user, app or brand by id
  maker get --id=ID --what=WHAT --where=WHERE     # List a user, app or brand by id
  maker help [COMMAND]                            # Describe available commands or one ...
```
Create an app on App Registry
```
$ ./bin/maker create --what=app --where=apps
app created:
id: 13
name: alex123
developer_id: 10
```

## Got a new service?
EASY!

1. Create a .json file in config/
2. Define your service:
  * uri: service URL
  * path: endpoint
  * headers: required headers
  * body: required params
  * output: array of strings/keys returned by the service so it displays it back to you when done

Example:
```
{
  "uri": "https://apps.bcservices.dev",
  "path": "/apps",
  "headers": {
    "client_id": "nngijicjmjv2szrqsg7un6r0n3rmdp2",
    "auth_token": "53iciy27zgzitv2yjmac96rha8b4a2w",
    "content-type": "application/json"
  },
  "body": {
    "name": "alex123",
    "user_id" : "10"
  },
  "output": [
    "id",
    "name",
    "developer_id"
  ]
}
```

## Roadmap
- Generate random data
- Add tests
- Instructions about environment variables (client_id & auth_token)
