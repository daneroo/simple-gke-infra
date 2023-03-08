# simple-gke-infra

Progressive experiment to stand up some resources on GCP.

## Stage 1: two containers

- One hosting a static site
- One providing a simple service (return the current time as JSON)

### 1.1: Static site (with nginx)

```bash
cd site
docker build  -t coco .  # image size: 142MB
# run the container mapping the host port 8080 to the container port 80
docker run --rm -p 8080:80  coco
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
