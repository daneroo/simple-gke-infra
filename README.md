# simple-gke-infra

Progressive experiment to stand up some resources on GCP.

## Stage 1: two containers

- One hosting a static site
- One providing a simple service (return the current time as JSON)

`tl;dr`: build and run everything with `docker compose`.

```bash
docker compose -f compose/compose.yaml build
docker compose -f compose/compose.yaml up
```

Then open your browser to:

- NGinx Site: <http://localhost:8080>
- Caddy Site: <http://localhost:8081>
- Go Time Service: <http://localhost:8082>
- Deno Time Service: <http://localhost:8083>
- Django Time Service: <http://localhost:8084/api/time>

### 1.1: Static site (with `nginx`)

Run the following commands, then open your browser to <http://localhost:8080>

```bash
docker compose -f compose/compose.yaml build nginx-site
docker compose -f compose/compose.yaml up nginx-site
```

<details><summary>Refinements</summary>

#### Refinements

Remove the odd `${PORT) substitution in the nginx:default.template file and Dockerfile:RUN command:

```Dockerfile
CMD envsubst < /etc/nginx/conf.d/default.template > /etc/nginx/conf.d/default.conf && exec nginx -g 'daemon off;'
# becomes
CMD exec nginx -g 'daemon off;'
```

This simplifies the docker run command as well:

```bash
docker run --rm -p 1312:1312 -ePORT  coco
# to
docker run --rm -p 1312:80  coco
```

Finally make a better looking html file!

</details>

### 1.2 alternate: Static site (with `caddy`)

Run the following commands, then open your browser to <http://localhost:8081>

```bash
docker compose -f compose/compose.yaml build caddy-site
docker compose -f compose/compose.yaml up caddy-site
```

### 2.1: Time service built with `go`

Run the following commands, then open your browser to <http://localhost:8082>

```bash
docker compose -f compose/compose.yaml build go-time
docker compose -f compose/compose.yaml up go-time
```

### 2.2 alternate: Time service built with `deno`

Also see a specific [example in their manual for Cloud Run using Oak](https://deno.land/manual@v1.31.0/advanced/deploying_deno/google_cloud_run)

```bash
curl -fsSL https://deno.land/x/install/install.sh | sh
cd deno-time
deno run --allow-net deno-time/server.ts
```

Run the following commands, then open your browser to <http://localhost:8083>

```bash
docker compose -f compose/compose.yaml build deno-time
docker compose -f compose/compose.yaml up deno-time
```

### 2.3 alternate: Time service built with `django`

Also see a specific [example in their manual for Cloud Run using Oak](https://deno.land/manual@v1.31.0/advanced/deploying_deno/google_cloud_run)

Run the following commands, then open your browser to <http://localhost:8084/api/time>

```bash
docker compose -f compose/compose.yaml build django-time
docker compose -f compose/compose.yaml up django-time
```

## Extras: load testing our service

This is just for linux/CodeSpaces. If you're on a Mac, or windows, see [The repos Install notes](wget "https://hey-release.s3.us-east-2.amazonaws.com/hey_linux_amd64"). There are pre-built binaries for a you too.

```bash
wget 'https://hey-release.s3.us-east-2.amazonaws.com/hey_linux_amd64'
chmod +x hey_linux_amd64

# load test the go-time service
# 10000 requests, 100 concurrent
./hey_linux_amd64 -n 10000 -c 100 http://localhost:8082
./hey_linux_amd64 -n 10000 -c 100 http://localhost:8083
./hey_linux_amd64 -n 10000 -c 100 http://localhost:8084/api/time
```

### Results

This was for the go-time server, running on my local machine, with 10000 requests, 100 concurrent.

```txt
Summary:
  Total:        0.9741 secs
  Slowest:      0.0784 secs
  Fastest:      0.0001 secs
  Average:      0.0090 secs
  Requests/sec: 10266.3278

  Total data:   408887 bytes
  Size/request: 40 bytes

Response time histogram:
  0.000 [1]     |
  0.008 [5180]  |■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
  0.016 [3443]  |■■■■■■■■■■■■■■■■■■■■■■■■■■■
  0.024 [1105]  |■■■■■■■■■
  0.031 [161]   |■
  0.039 [46]    |
  0.047 [44]    |
  0.055 [12]    |
  0.063 [4]     |
  0.071 [0]     |
  0.078 [4]     |


Latency distribution:
  10% in 0.0013 secs
  25% in 0.0040 secs
  50% in 0.0077 secs
  75% in 0.0125 secs
  90% in 0.0176 secs
  95% in 0.0212 secs
  99% in 0.0319 secs

Details (average, fastest, slowest):
  DNS+dialup:   0.0000 secs, 0.0001 secs, 0.0784 secs
  DNS-lookup:   0.0000 secs, 0.0000 secs, 0.0121 secs
  req write:    0.0000 secs, 0.0000 secs, 0.0109 secs
  resp wait:    0.0084 secs, 0.0001 secs, 0.0667 secs
  resp read:    0.0004 secs, 0.0000 secs, 0.0124 secs

Status code distribution:
  [200] 10000 responses
```

Summary:

for 10000 requests, 100 concurrent

| Service     | Requests/sec |
|-------------|-------------:|
| go-time     |      10266.3 |
| deno-time   |       5718.9 |
| django-time |        520.3 |



## Extras: Image Sizes

```bash
 $ docker images
REPOSITORY            TAG       IMAGE ID       CREATED         SIZE
compose-django-time   latest    a41f1a887396   6 minutes ago   972MB
compose-deno-time     latest    487ae5658e6e   2 hours ago     122MB
compose-go-time       latest    1df4880c7283   2 hours ago     14.3MB <---- Nice!
compose-nginx-site    latest    ca03ce1b5089   2 hours ago     142MB
compose-caddy-site    latest    acfd32b5538f   2 hours ago     46MB
```
