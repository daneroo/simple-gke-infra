# Using Cloud Build Triggers

There is a limitation of 100 steps in a cloudbuild.yaml file.

So we will make separate triggers and cloubuild.yaml files for each service.


```bash
export PROJECT_ID="pdcp-cloud-009-danl"
export REGION="northamerica-northeast1"

gcloud builds triggers list --region ${REGION}

gcloud builds triggers create github \
  --name=test-caddy-001 \
  --region ${REGION} \
  --repo-name=simple-gke-infra \
  --repo-owner=daneroo \
  --branch-pattern="^main$" \
  --build-config=caddy-site/cloudbuild.yaml

```

