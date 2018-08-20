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

## Add-Ons:

You can use this with a Nginx Reverse Proxy:
- https://github.com/ruanbekker/nginx-cache-armhf

## Docker Hub Image:

- https://hub.docker.com/r/rbekker87/armhf-ghost/

## Setup a Stack on Swarm with Nginx and Ghost:

```bash
$ wget https://raw.githubusercontent.com/ruanbekker/ghost-armhf/master/docker-compose.yml
```

Replace your traefik labels, then deploy the stack:

```bash
$ docker stack deploy -c docker-compose.yml newblog 
Creating service newblog_frontend-blog
Creating service newblog_backend-blog
```

Once your stack is deployed, test out the caching:

```bash
$ curl -I http://newblog.domain.co.za
HTTP/1.1 200 OK
Cache-Control: max-age=86400
Cache-Control: public
Content-Length: 16806
Content-Type: text/html; charset=utf-8
Date: Mon, 20 Aug 2018 22:54:12 GMT
Etag: W/"41a6-vvltA1T18qr7iPjx21ccHA+5cgc"
Expires: Tue, 21 Aug 2018 22:54:12 GMT
Server: nginx
Vary: Accept-Encoding
Vary: Accept-Encoding
X-Cache-Status: MISS
X-Powered-By: Express

$ curl -I http://newblog.domain.co.za
HTTP/1.1 200 OK
Cache-Control: max-age=86400
Cache-Control: public
Content-Length: 16806
Content-Type: text/html; charset=utf-8
Date: Mon, 20 Aug 2018 22:54:34 GMT
Etag: W/"41a6-vvltA1T18qr7iPjx21ccHA+5cgc"
Expires: Tue, 21 Aug 2018 22:54:34 GMT
Server: nginx
Vary: Accept-Encoding
Vary: Accept-Encoding
X-Cache-Status: HIT
X-Powered-By: Express
```
