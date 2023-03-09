# Deploy to GCP using bash/cli

See also `im-qcic/cloudrun`

```bash
# so we can push from a local docker registry
gcloud auth login


export PROJECT_ID="pdcp-cloud-009-danl"
export REGION="northamerica-northeast1"
gcloud config set project ${PROJECT_ID}
gcloud config set run/region northamerica-northeast1
# create an Artifact Registry repository (Console for now)
# named it 'simple-gke-infra' put it in 'northamerica-northeast1

gcloud auth configure-docker northamerica-northeast1-docker.pkg.dev
# docker tag <LOCAL_IMAGE_NAME> gcr.io/<PROJECT_ID>/<IMAGE_NAME>

# Pushes should be of the form docker push HOST-NAME/PROJECT-ID/REPOSITORY/IMAGE:TAG
docker tag compose-go-time:latest northamerica-northeast1-docker.pkg.dev/${PROJECT_ID}/simple-gke-infra/go-time:latest
docker push northamerica-northeast1-docker.pkg.dev/${PROJECT_ID}/simple-gke-infra/go-time:latest

# Now, in a loop
for i in django-time go-time deno-time nginx-site caddy-site; do
  # destination tag
  docker tag compose-$i:latest northamerica-northeast1-docker.pkg.dev/${PROJECT_ID}/simple-gke-infra/$i:latest
  # push to registry
  docker push northamerica-northeast1-docker.pkg.dev/${PROJECT_ID}/simple-gke-infra/$i:latest
  # deploy to cloud run
  gcloud run deploy $i --allow-unauthenticated --image northamerica-northeast1-docker.pkg.dev/pdcp-cloud-009-danl/simple-gke-infra/$i:latest
done
```
