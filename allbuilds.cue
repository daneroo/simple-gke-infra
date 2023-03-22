package cloudbuild

cloudbuild: [string]: {
	steps: [{
		// Build the container image
		name: "gcr.io/cloud-builders/docker"
		args: [
			"build",
			"-t",
			"${_REGION}-docker.pkg.dev/${PROJECT_ID}/${_ARTIFACT_REGISTRY}/${_SERVICE_NAME}:${COMMIT_SHA}",
			"${_SERVICE_NAME}/.",
		]
	}, {
		// Fully qualified container registry image name
		// docker context _root
		// Push the container image to Container Registry
		name: "gcr.io/cloud-builders/docker"
		args: [
			"push",
			"${_REGION}-docker.pkg.dev/${PROJECT_ID}/${_ARTIFACT_REGISTRY}/${_SERVICE_NAME}:${COMMIT_SHA}",
		]
	}, {
		// Deploy container image to Cloud Run
		name:       "gcr.io/google.com/cloudsdktool/cloud-sdk"
		entrypoint: "gcloud"
		args: [
			"run",
			"deploy",
			"${_SERVICE_NAME}",
			"--image",
			"${_REGION}-docker.pkg.dev/${PROJECT_ID}/${_ARTIFACT_REGISTRY}/${_SERVICE_NAME}:${COMMIT_SHA}",
			"--region",
			"${_REGION}",
		]
	}]
	substitutions: {
		// The must start with a "_" (_[A-Z0-9_]+)
		"_ARTIFACT_REGISTRY": "simple-gke-infra"
		"_REGION":            "northamerica-northeast1"
	}
	images: [
		"${_REGION}-docker.pkg.dev/${PROJECT_ID}/${_ARTIFACT_REGISTRY}/${_SERVICE_NAME}:${COMMIT_SHA}",
	]
}
"cloudbuild": "caddy-site": {
	substitutions: {
		"_SERVICE_NAME": "caddy-site"
	}
}
"cloudbuild": "go-time": {

	substitutions: {
		"_SERVICE_NAME": "go-time"
	}
}
"cloudbuild": "django-time": {

	substitutions: {
		"_SERVICE_NAME": "django-time"
	}
}
"cloudbuild": "deno-time": {

	substitutions: {
		"_SERVICE_NAME": "deno-time"
	}
}
"cloudbuild": "nginx-site": {

	substitutions: {
		"_SERVICE_NAME": "nginx-site"
	}
}
