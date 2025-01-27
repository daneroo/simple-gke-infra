# Deploy to GCP using bash/cli (from Cloud Shell for example)

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

## DNS

After delegating my my own subdomain `dl.phac.alpha.canada.ca` to Google Cloud DNS in my own project,
I created a `CNAME` record for each of the services  pointing to `go-time-2m3hexrmga-nn.a.run.app`

This would be much easier with Cloud Run domain mappings, but they are not supported in any region that we are allowed to use inside our GCP environment.

Traces of my failed attempt at provisioning a domain mapping:

```bash
gcloud run services list
# get the current url
gcloud run services describe nginx-site --format="value(status.url)"
#  returns https://nginx-site-2m3hexrmga-nn.a.run.app

# create the CNAME entry: nginx-site.r.dl.phac.alpha.canada.ca
# which point to the url above; notice the trailing dot "nginx-site-2m3hexrmga-nn.a.run.app."

export PROJECT_ID="pdcp-cloud-009-danl"

gcloud dns record-sets transaction start --zone=dl-phac-alpha-canada-ca --project=${PROJECT_ID}
gcloud dns record-sets transaction add --zone=dl-phac-alpha-canada-ca --name=nginx-site.r.dl.phac.alpha.canada.ca. --ttl=300 --type=CNAME "nginx-site-2m3hexrmga-nn.a.run.app." --project=${PROJECT_ID}
gcloud dns record-sets transaction execute --zone=dl-phac-alpha-canada-ca --project=${PROJECT_ID}

# Confirm it worked
gcloud dns record-sets list --zone=dl-phac-alpha-canada-ca --project=${PROJECT_ID}
gcloud dns record-sets describe --zone=dl-phac-alpha-canada-ca --project=${PROJECT_ID} --type CNAME nginx-site.r.dl.phac.alpha.canada.ca

# Remove it
gcloud dns record-sets delete --zone=dl-phac-alpha-canada-ca --project=${PROJECT_ID} --type CNAME nginx-site.r.dl.phac.alpha.canada.ca
```
