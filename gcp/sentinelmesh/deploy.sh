#!/usr/bin/env bash
set -euo pipefail

: "${GCP_PROJECT_ID:?Set GCP_PROJECT_ID}"
: "${SENTINELMESH_API_KEY:?Set SENTINELMESH_API_KEY}"
REGION="${GOOGLE_CLOUD_LOCATION:-us-central1}"
SERVICE="sentinelmesh-orchestrator"
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

(
  cd "$ROOT_DIR"
  pnpm install --frozen-lockfile
  PORT=8080 BASE_PATH=/ pnpm --filter @workspace/sentinelmesh run build
)

gcloud config set project "$GCP_PROJECT_ID"
gcloud services enable run.googleapis.com firestore.googleapis.com aiplatform.googleapis.com logging.googleapis.com
gcloud firestore databases create --location="$REGION" --type=firestore-native 2>/dev/null || true
PROJECT_NUMBER="$(gcloud projects describe "$GCP_PROJECT_ID" --format='value(projectNumber)')"
RUNTIME_SERVICE_ACCOUNT="${CLOUD_RUN_SERVICE_ACCOUNT:-${PROJECT_NUMBER}-compute@developer.gserviceaccount.com}"
if ! gcloud projects get-iam-policy "$GCP_PROJECT_ID" \
  --flatten="bindings[].members" \
  --filter="bindings.role=roles/aiplatform.user AND bindings.members=serviceAccount:${RUNTIME_SERVICE_ACCOUNT}" \
  --format='value(bindings.role)' | grep -q 'roles/aiplatform.user'; then
  echo "WARNING: ${RUNTIME_SERVICE_ACCOUNT} was not found with roles/aiplatform.user at project level."
  echo "The Cloud Run service may deploy but Gemini calls can fail at runtime."
  if [[ "${VERIFY_VERTEX_IAM:-false}" == "true" ]]; then
    exit 1
  fi
fi
gcloud builds submit \
  --tag "gcr.io/$GCP_PROJECT_ID/$SERVICE" \
  --file "$ROOT_DIR/gcp/sentinelmesh/Dockerfile" \
  "$ROOT_DIR"
gcloud run deploy "$SERVICE" \
  --image "gcr.io/$GCP_PROJECT_ID/$SERVICE" \
  --region "$REGION" \
  --platform managed \
  --service-account "$RUNTIME_SERVICE_ACCOUNT" \
  --allow-unauthenticated \
  --set-env-vars "GCP_PROJECT_ID=$GCP_PROJECT_ID,GOOGLE_CLOUD_PROJECT=$GCP_PROJECT_ID,GOOGLE_CLOUD_LOCATION=$REGION,GOOGLE_GENAI_USE_VERTEXAI=TRUE,GEMINI_MODEL=gemini-3.5-flash,SENTINELMESH_API_KEY=$SENTINELMESH_API_KEY" \
  --min-instances 0 \
  --max-instances 3 \
  --cpu 1 \
  --memory 1Gi