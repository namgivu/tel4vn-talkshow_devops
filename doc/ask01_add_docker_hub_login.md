### What’s missing
Your workflow builds and pushes an image to Google Artifact Registry (GAR), but it never authenticates Docker to that registry before `docker push`. The comment says “add docker hub login”, but given `IMAGE_NAME` points to GAR (`${{ secrets.STAGING_REGION }}-docker.pkg.dev/...`), you actually need a GAR login, not Docker Hub.

Below are two options. Pick ONE that matches your intent.

---

### Option A (Recommended here): Log in to Google Artifact Registry
This matches your `IMAGE_NAME` and push target.

Add this step where the `#TODO add docker hub login` comment is (before Build image):

```yaml
      - name: Log in to Google Artifact Registry
        uses: docker/login-action@v3
        with:
          registry: ${{ secrets.STAGING_REGION }}-docker.pkg.dev
          username: _json_key
          password: ${{ secrets.STAGING_GAR_SA_KEY_JSON }}
```

Required GitHub secrets:
- `STAGING_REGION` (e.g., `asia-southeast1` or `us-central1`)
- `STAGING_PROJECT_ID` (your GCP project ID)
- `STAGING_GAR_REPOSITORY` (GAR repo name)
- `STAGING_GAR_SA_KEY_JSON` (JSON content of a GCP service account key with `roles/artifactregistry.writer`)

Minimal full job with the new step in-place:

```yaml
name: ci-stg--vitereactjs_webapp

on:
  push:
    branches: [main]
    paths: [vitereactjs_webapp/**]
  workflow_dispatch:

env:
  IMAGE_NAME: ${{ secrets.STAGING_REGION }}-docker.pkg.dev/${{ secrets.STAGING_PROJECT_ID }}/${{ secrets.STAGING_GAR_REPOSITORY }}/admin-web-staging

jobs:
  build-and-deploy:
    runs-on: ubuntu-22.04

    steps:
      - name: Log in to Google Artifact Registry
        uses: docker/login-action@v3
        with:
          registry: ${{ secrets.STAGING_REGION }}-docker.pkg.dev
          username: _json_key
          password: ${{ secrets.STAGING_GAR_SA_KEY_JSON }}

      - name: Checkout
        uses: actions/checkout@v4

      - name: Build image
        run: docker build . --file frontend.Dockerfile --build-arg APP_NAME=admin-web --tag ${{ env.IMAGE_NAME }}:${{ github.sha }} --tag ${{ env.IMAGE_NAME }}:latest

      - name: Push image
        run: docker push ${{ env.IMAGE_NAME }}:latest

      - name: Deploy
        run: |
          echo "${{ secrets.STAGING_SSH_PRIVATE_KEY }}" > private_key && chmod 600 private_key
          ssh -o StrictHostKeyChecking=no -i private_key ${{ secrets.STAGING_SSH_USER }}@${{ secrets.STAGING_SSH_HOST }} << EOSSH
            set -e
            set -x

            cd xstar-automation 
            git checkout main 
            git fetch --all 
            git reset --hard 
            git pull --rebase 
            gcloud auth configure-docker ${{ secrets.STAGING_REGION }}-docker.pkg.dev --quiet 
            echo "${{ vars.STAGING_ADMIN_WEB_ENV }}" > ./apps/admin-web/.env 
            sed -i "s#ADMIN_WEB_IMAGE=.*#ADMIN_WEB_IMAGE=${{ env.IMAGE_NAME }}:latest#" .env 
            docker compose --profile admin-web up -d 
            docker system prune --volumes -f
          EOSSH
```

Notes:
- Using `docker/login-action` avoids needing to install and auth `gcloud` inside the build job.
- Ensure the service account belongs to the same project where GAR repository exists and has write access.

---

### Option B (Only if you truly want Docker Hub)
If you intend to push to Docker Hub instead, change the `IMAGE_NAME` and add a Docker Hub login step.

1) Update `env.IMAGE_NAME` to Docker Hub naming:
```yaml
env:
  IMAGE_NAME: docker.io/${{ secrets.DOCKERHUB_USERNAME }}/admin-web-staging
```

2) Add Docker Hub login step at the TODO position:
```yaml
      - name: Log in to Docker Hub
        uses: docker/login-action@v3
        with:
          username: ${{ secrets.DOCKERHUB_USERNAME }}
          password: ${{ secrets.DOCKERHUB_TOKEN }}
```

3) Keep the build/push steps as-is; they will now push to Docker Hub.

Required GitHub secrets for Docker Hub:
- `DOCKERHUB_USERNAME`
- `DOCKERHUB_TOKEN` (a PAT or access token)

---

### Troubleshooting tips
- 401/denied on push: verify the `registry` value matches exactly your GAR hostname (e.g., `us-central1-docker.pkg.dev`).
- 404 repository not found: ensure the GAR repository exists and its format is Docker, not Maven/NPM.
- If multi-arch builds are needed, add `docker/setup-qemu-action@v3` and `docker/setup-buildx-action@v3` and switch to `docker/build-push-action@v6` with `push: true`.

If you confirm GAR vs Docker Hub target, I can provide the finalized workflow block tailored to your environment values.