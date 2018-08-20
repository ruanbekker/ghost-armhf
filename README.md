# ghost-armhf
Ghost Blog on Docker for ARM

## Environment Variables:

```
- SERVER_URL=mydomain.com
```

Updates the url in the below config:

```
{
  "url": "http://localhost:2368",
  "server": {
    "port": 2368,
    "host": "0.0.0.0"
  },
...
```

If no environment variable is specified, the defaults will be kept.
