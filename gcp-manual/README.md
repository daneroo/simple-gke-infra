# Deploy to GCP using bash/cli

See also `im-qcic/cloudrun`

```bash
# so we can push from a local docker registry
gcloud auth login


# project name is phx-danl
export PROJECT_ID="pdcp-cloud-009-danl"
export REGION="northamerica-northeast1"
gcloud config set project ${PROJECT_ID}
gcloud config set run/region ${REGION}
# create an Artifact Registry repository (Console for now)
# named it 'simple-gke-infra' put it in '${REGION}

gcloud auth configure-docker ${REGION}-docker.pkg.dev
# docker tag <LOCAL_IMAGE_NAME> gcr.io/<PROJECT_ID>/<IMAGE_NAME>

# e.g.: Pushes should be of the form docker push HOST-NAME/PROJECT-ID/REPOSITORY/IMAGE:TAG
docker tag compose-go-time:latest ${REGION}-docker.pkg.dev/${PROJECT_ID}/simple-gke-infra/go-time:latest
docker push ${REGION}-docker.pkg.dev/${PROJECT_ID}/simple-gke-infra/go-time:latest

# Now, in a loop
for i in django-time go-time deno-time nginx-site caddy-site; do
  # destination tag
  docker tag compose-$i:latest ${REGION}-docker.pkg.dev/${PROJECT_ID}/simple-gke-infra/$i:latest
  # push to registry
  docker push ${REGION}-docker.pkg.dev/${PROJECT_ID}/simple-gke-infra/$i:latest
  # deploy to cloud run
  gcloud run deploy $i --allow-unauthenticated --image ${REGION}-docker.pkg.dev/pdcp-cloud-009-danl/simple-gke-infra/$i:latest
done
```

## Hey!

This is how you [install hey](https://github.com/rakyll/hey#installation)
For the Google Cloud shell:

```bash
wget https://hey-release.s3.us-east-2.amazonaws.com/hey_linux_amd64
chmod +x hey_linux_amd64 && mv hey_linux_amd64 /usr/local/bin/hey

# you will have a fdifferenet hostname prefix (2m3hexrmga-nn.a.run.app) in my case
# 10000 requests, 100 concurrent
./hey_linux_amd64 -n 10000 -c 100 https://go-time-2m3hexrmga-nn.a.run.app |grep 'Requests/sec'
./hey_linux_amd64 -n 10000 -c 100 https://deno-time-2m3hexrmga-nn.a.run.app |grep 'Requests/sec'
./hey_linux_amd64 -n 10000 -c 100 https://django-time-2m3hexrmga-nn.a.run.app/api/time |grep 'Requests/sec'
```

Testing from Cloud Shell:

| Service     | Requests/sec |
|-------------|-------------:|
| go-time     |       2627.1 |
| deno-time   |       1915.7 |
| django-time |        162.1 |
