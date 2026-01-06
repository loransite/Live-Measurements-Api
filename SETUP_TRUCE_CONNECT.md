# Setup for truce-connect GCP Project

## ⚠️ Billing Required

Your project **truce-connect** (ID: `truce-connect`) needs billing enabled to use Cloud Run.

## 📋 Enable Billing

### Option 1: Via Google Cloud Console (Easiest)

1. Go to: https://console.cloud.google.com/billing/linkedaccount?project=truce-connect
2. Click "Link a billing account"
3. Select an existing billing account or create a new one
4. Click "Set account"

### Option 2: Create New Billing Account

1. Go to: https://console.cloud.google.com/billing
2. Click "Create Account"
3. Fill in your payment information
4. Link it to project `truce-connect`

**Note**: Google Cloud offers **$300 free credits** for new accounts!

## ✅ After Enabling Billing

Once billing is enabled, run these commands:

```bash
# 1. Set your project (already done)
gcloud config set project truce-connect

# 2. Enable required APIs
gcloud services enable run.googleapis.com \
    cloudbuild.googleapis.com \
    containerregistry.googleapis.com

# 3. Deploy your app
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

Or use the interactive script:
```bash
./deploy-gcp.sh
```

## 💰 Cost Information

**Free Tier Includes:**
- First 2 million requests per month
- 360,000 GB-seconds of memory
- 180,000 vCPU-seconds

**Your App (4GB RAM, 2 CPU):**
- ~12,000 requests/month FREE
- Beyond free tier: ~$0.03 per request

**Plus $300 free credits** if you're a new GCP user!

## 🔐 Current Project Configuration

- **Project Name**: truce connect
- **Project ID**: truce-connect
- **Project Number**: 943725370346

## 🚀 Quick Deploy Command (After Billing Enabled)

```bash
# All-in-one command
gcloud run deploy live-measurements-api \
    --source . \
    --project truce-connect \
    --region us-central1 \
    --allow-unauthenticated \
    --memory 4Gi \
    --cpu 2 \
    --timeout 300s
```

## 📞 Need Help?

- [Enable Billing Guide](https://cloud.google.com/billing/docs/how-to/modify-project)
- [Free Tier Details](https://cloud.google.com/free)
- [Cloud Run Pricing](https://cloud.google.com/run/pricing)

## ✅ Next Steps

1. Enable billing: https://console.cloud.google.com/billing/linkedaccount?project=truce-connect
2. Return here and run: `./deploy-gcp.sh`
3. Your API will be live in ~5-10 minutes!
