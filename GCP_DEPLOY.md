# Google Cloud Run Deployment Guide

## 🎯 Why Google Cloud Run?

Perfect for your ML/AI FastAPI app because:
- ✅ **No size limits** like Vercel (50 MB)
- ✅ **Handles large ML models** (PyTorch, MediaPipe, OpenCV)
- ✅ **Automatic scaling** from 0 to thousands of instances
- ✅ **Pay only for usage** (generous free tier: 2 million requests/month)
- ✅ **Up to 60 minutes timeout** (vs Vercel's 10 seconds)
- ✅ **Up to 32 GB memory** available

## 📋 Prerequisites

1. **Google Cloud Account** (free tier includes $300 credits)
   - Sign up at: https://cloud.google.com/free

2. **Google Cloud CLI (gcloud)**
   - Install: https://cloud.google.com/sdk/docs/install

## 🚀 Deployment Steps

### Step 1: Install Google Cloud CLI

**Linux/Mac:**
```bash
curl https://sdk.cloud.google.com | bash
exec -l $SHELL
```

**Windows:**
Download from: https://cloud.google.com/sdk/docs/install

### Step 2: Initialize and Authenticate

```bash
# Initialize gcloud
gcloud init

# Login to your Google account
gcloud auth login

# Set your project (replace YOUR_PROJECT_ID)
gcloud config set project YOUR_PROJECT_ID

# Enable required APIs
gcloud services enable run.googleapis.com
gcloud services enable containerregistry.googleapis.com
gcloud services enable cloudbuild.googleapis.com
```

### Step 3: Deploy to Cloud Run

**Option A: Deploy Directly from Source (Easiest)**

```bash
# Deploy from your project directory
gcloud run deploy live-measurements-api \
  --source . \
  --platform managed \
  --region us-central1 \
  --allow-unauthenticated \
  --memory 4Gi \
  --cpu 2 \
  --timeout 300s \
  --max-instances 10

# Use --memory 4Gi because ML models need more RAM
# Use --timeout 300s (5 minutes) for image processing
```

**Option B: Deploy Using Docker (More Control)**

```bash
# Set your project ID
export PROJECT_ID=YOUR_PROJECT_ID
export REGION=us-central1

# Build and push Docker image
gcloud builds submit --tag gcr.io/$PROJECT_ID/live-measurements-api

# Deploy to Cloud Run
gcloud run deploy live-measurements-api \
  --image gcr.io/$PROJECT_ID/live-measurements-api \
  --platform managed \
  --region $REGION \
  --allow-unauthenticated \
  --memory 4Gi \
  --cpu 2 \
  --timeout 300s \
  --max-instances 10
```

### Step 4: Get Your Service URL

After deployment, you'll see:
```
Service [live-measurements-api] revision [live-measurements-api-00001-xxx] has been deployed and is serving 100 percent of traffic.
Service URL: https://live-measurements-api-xxxxx-uc.a.run.app
```

## 🔧 Configuration Options Explained

| Option | Value | Why |
|--------|-------|-----|
| `--memory` | `4Gi` | ML models need more RAM (default is 512 MB) |
| `--cpu` | `2` | Faster image processing with 2 vCPUs |
| `--timeout` | `300s` | 5 minutes for heavy processing (default is 5 mins, max 60 mins) |
| `--max-instances` | `10` | Prevent runaway costs (free tier covers this) |
| `--allow-unauthenticated` | - | Public API (remove for private) |
| `--region` | `us-central1` | Choose closest to your users |

## 📍 Available Regions

Choose the closest region to your users:
- `us-central1` (Iowa) - Generally cheapest
- `us-east1` (South Carolina)
- `europe-west1` (Belgium)
- `asia-northeast1` (Tokyo)
- `asia-southeast1` (Singapore)

## 💰 Cost Estimation (Free Tier)

**Free Tier Includes:**
- 2 million requests/month
- 360,000 GB-seconds of memory
- 180,000 vCPU-seconds

**Your App (with 4GB memory, 2 CPU):**
- Each request ~5 seconds = ~12,000 free requests/month
- Beyond free tier: ~$0.03 per request

**Estimated Monthly Cost:**
- Low usage (1,000 requests): **FREE**
- Medium (10,000 requests): **~$20-30**
- High (100,000 requests): **~$200-300**

## 🧪 Test Your Deployed API

```bash
# Get your service URL
export SERVICE_URL=$(gcloud run services describe live-measurements-api --region us-central1 --format 'value(status.url)')

# Test the API
curl -X POST "$SERVICE_URL/upload_images" \
  -F "front=@front.jpeg" \
  -F "left_side=@left_side.jpeg" \
  -F "height_cm=170"

# View API documentation
echo "$SERVICE_URL/docs"
```

## 📊 Monitor Your Service

```bash
# View logs
gcloud run services logs read live-measurements-api --region us-central1

# Get service details
gcloud run services describe live-measurements-api --region us-central1

# List all services
gcloud run services list
```

## 🔄 Update Your Service

```bash
# After making code changes, redeploy:
gcloud run deploy live-measurements-api \
  --source . \
  --region us-central1

# Or specify new configuration:
gcloud run services update live-measurements-api \
  --region us-central1 \
  --memory 8Gi \
  --cpu 4
```

## 🔐 Add Authentication (Optional)

If you want to protect your API:

```bash
# Deploy with authentication required
gcloud run deploy live-measurements-api \
  --source . \
  --region us-central1 \
  --no-allow-unauthenticated

# Then add CORS if needed
# Add this to your app.py:
```

```python
from fastapi.middleware.cors import CORSMiddleware

app.add_middleware(
    CORSMiddleware,
    allow_origins=["https://your-frontend.com"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
```

## 🌍 Custom Domain (Optional)

```bash
# Map custom domain
gcloud run domain-mappings create \
  --service live-measurements-api \
  --domain api.yourdomain.com \
  --region us-central1
```

## 🐛 Troubleshooting

### Issue: "Permission denied"
```bash
gcloud auth login
gcloud config set project YOUR_PROJECT_ID
```

### Issue: "Deployment timeout"
```bash
# Increase build timeout
gcloud builds submit --timeout=1h --tag gcr.io/$PROJECT_ID/live-measurements-api
```

### Issue: "Out of memory"
```bash
# Increase memory allocation
gcloud run services update live-measurements-api \
  --memory 8Gi \
  --region us-central1
```

### Issue: "Request timeout"
```bash
# Increase timeout
gcloud run services update live-measurements-api \
  --timeout 600s \
  --region us-central1
```

## 📈 Performance Optimization

### 1. Enable CPU boost during startup
```bash
gcloud run services update live-measurements-api \
  --cpu-boost \
  --region us-central1
```

### 2. Keep instances warm (reduce cold starts)
```bash
gcloud run services update live-measurements-api \
  --min-instances 1 \
  --region us-central1
```
⚠️ This costs money even with no traffic!

### 3. Optimize Docker image size
- Use multi-stage builds
- Remove unnecessary dependencies
- Use `.dockerignore` (already created)

## 🗑️ Clean Up / Delete Service

```bash
# Delete the service
gcloud run services delete live-measurements-api --region us-central1

# Delete Docker images
gcloud container images delete gcr.io/$PROJECT_ID/live-measurements-api
```

## 🔗 Useful Commands Cheat Sheet

```bash
# Deploy
gcloud run deploy live-measurements-api --source . --region us-central1

# Get URL
gcloud run services describe live-measurements-api --region us-central1 --format 'value(status.url)'

# View logs (live)
gcloud run services logs tail live-measurements-api --region us-central1

# Update memory
gcloud run services update live-measurements-api --memory 8Gi --region us-central1

# List all services
gcloud run services list

# Service details
gcloud run services describe live-measurements-api --region us-central1
```

## 📚 Additional Resources

- [Cloud Run Documentation](https://cloud.google.com/run/docs)
- [Cloud Run Pricing](https://cloud.google.com/run/pricing)
- [Cloud Run Quotas](https://cloud.google.com/run/quotas)
- [FastAPI on Cloud Run](https://cloud.google.com/run/docs/quickstarts/build-and-deploy/deploy-python-service)

## ✅ Quick Start Checklist

- [ ] Install Google Cloud CLI
- [ ] Run `gcloud init` and login
- [ ] Enable required APIs
- [ ] Run deployment command
- [ ] Test your API endpoint
- [ ] Check logs for any issues
- [ ] Set up monitoring (optional)
- [ ] Configure custom domain (optional)

## 🎉 You're Ready!

Run this single command to deploy:

```bash
gcloud run deploy live-measurements-api \
  --source . \
  --platform managed \
  --region us-central1 \
  --allow-unauthenticated \
  --memory 4Gi \
  --cpu 2 \
  --timeout 300s \
  --max-instances 10
```

Your API will be live in ~5-10 minutes! 🚀
