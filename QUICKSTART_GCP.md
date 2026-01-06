# 🚀 Quick Start - Deploy to Google Cloud Run

## One-Command Deploy

```bash
./deploy-gcp.sh
```

Or manually:

```bash
gcloud run deploy live-measurements-api \
  --source . \
  --region us-central1 \
  --allow-unauthenticated \
  --memory 4Gi \
  --cpu 2 \
  --timeout 300s \
  --max-instances 10
```

## Prerequisites

1. Install Google Cloud CLI:
```bash
curl https://sdk.cloud.google.com | bash
exec -l $SHELL
```

2. Login and setup:
```bash
gcloud init
gcloud auth login
```

## Files Added for GCP

- ✅ `Dockerfile` - Container configuration
- ✅ `.dockerignore` - Exclude unnecessary files from build
- ✅ `.gcloudignore` - Exclude files from GCP deployment
- ✅ `deploy-gcp.sh` - Automated deployment script
- ✅ `test-api.sh` - Test your deployed API
- ✅ `GCP_DEPLOY.md` - Complete documentation

## After Deployment

Your service URL will be: `https://live-measurements-api-xxxxx-uc.a.run.app`

Test it:
```bash
./test-api.sh YOUR_SERVICE_URL
```

View logs:
```bash
gcloud run services logs tail live-measurements-api --region us-central1
```

Update:
```bash
gcloud run deploy live-measurements-api --source . --region us-central1
```

## Cost

- **Free tier**: 2 million requests/month
- **Your app**: ~12,000 free requests/month (with 4GB RAM)
- **Beyond free**: ~$0.03 per request

## Need Help?

See `GCP_DEPLOY.md` for complete documentation.
