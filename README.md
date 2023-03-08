# simple-gke-infra

Progressive experiment to stand up some resources on GCP.

## Stage 1: two containers

- One hosting a static site
- One providing a simple service (return the current time as JSON)

### 1.1: Static site (with nginx)

Run the following commands, then open your browser to <http://localhost:8080>

```bash
docker compose -f compose/compose.yaml build site
docker compose -f compose/compose.yaml up site
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
