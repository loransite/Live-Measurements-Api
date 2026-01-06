#!/bin/bash

# Deploy to truce-connect GCP project
# Run this after enabling billing

set -e

echo "🚀 Deploying to truce-connect project"
echo "======================================"
echo ""
echo "Project: truce-connect"
echo "Account: ogunmusireseyi01@gmail.com"
echo ""

# Check if billing is enabled by trying to enable APIs
echo "📋 Checking billing and enabling APIs..."
if gcloud services enable run.googleapis.com cloudbuild.googleapis.com containerregistry.googleapis.com --quiet 2>/dev/null; then
    echo "✅ APIs enabled successfully"
else
    echo "❌ ERROR: Billing not enabled"
    echo ""
    echo "Please enable billing at:"
    echo "https://console.cloud.google.com/billing/linkedaccount?project=truce-connect"
    echo ""
    echo "Google Cloud offers $300 free credits for new accounts!"
    exit 1
fi

echo ""
echo "🏗️  Deploying to Cloud Run..."
echo "   Region: us-central1"
echo "   Memory: 4GB"
echo "   CPU: 2 vCPUs"
echo "   This will take 5-10 minutes..."
echo ""

gcloud run deploy live-measurements-api \
    --source . \
    --project truce-connect \
    --platform managed \
    --region us-central1 \
    --allow-unauthenticated \
    --memory 4Gi \
    --cpu 2 \
    --timeout 300s \
    --max-instances 10 \
    --quiet

# Get service URL
SERVICE_URL=$(gcloud run services describe live-measurements-api --region us-central1 --format 'value(status.url)' --project truce-connect)

echo ""
echo "=========================================="
echo "✅ Deployment Complete!"
echo "=========================================="
echo ""
echo "🌍 Service URL: $SERVICE_URL"
echo ""
echo "📚 API Documentation: $SERVICE_URL/docs"
echo "📖 Alternative Docs: $SERVICE_URL/redoc"
echo ""
echo "🧪 Test your API:"
echo "  ./test-api.sh $SERVICE_URL"
echo ""
echo "Or manually:"
echo "  curl -X POST \"$SERVICE_URL/upload_images\" \\"
echo "    -F \"front=@front.jpeg\" \\"
echo "    -F \"left_side=@left_side.jpeg\" \\"
echo "    -F \"height_cm=170\""
echo ""
echo "📊 View logs:"
echo "  gcloud run services logs tail live-measurements-api --region us-central1 --project truce-connect"
echo ""
echo "🔄 Update service:"
echo "  ./deploy-truce.sh"
echo ""
