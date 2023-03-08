# Deploy to GCP using bash/cli

```bash
# so we can push from a local docker registry
gcloud auth login


export PROJECT_ID="pdcp-cloud-009-danl"
gcloud config set project ${PROJECT_ID}

# create an Artifact Registry repository (Console for now)
# named it 'simple-gke-infra' put it in 'northamerica-northeast1

gcloud auth configure-docker northamerica-northeast1-docker.pkg.dev
# docker tag <LOCAL_IMAGE_NAME> gcr.io/<PROJECT_ID>/<IMAGE_NAME>

# Pushes should be of the form docker push HOST-NAME/PROJECT-ID/REPOSITORY/IMAGE:TAG
docker tag compose-go-time:latest northamerica-northeast1-docker.pkg.dev/${PROJECT_ID}/simple-gke-infra/go-time:latest
docker push northamerica-northeast1-docker.pkg.dev/${PROJECT_ID}/simple-gke-infra/go-time:latest

# Now, in a loop
for i in django-time go-time deno-time nginx-site caddy-site; do
  docker tag compose-$i:latest northamerica-northeast1-docker.pkg.dev/${PROJECT_ID}/simple-gke-infra/$i:latest
  docker push northamerica-northeast1-docker.pkg.dev/${PROJECT_ID}/simple-gke-infra/$i:latest
done
```
