#!/bin/bash

# Google Cloud Run Deployment Script for Live Measurements API

set -e  # Exit on error

echo "🚀 Live Measurements API - GCP Cloud Run Deployment"
echo "=================================================="
echo ""

# Check if gcloud is installed
if ! command -v gcloud &> /dev/null; then
    echo "❌ Error: gcloud CLI is not installed"
    echo "📥 Install it from: https://cloud.google.com/sdk/docs/install"
    echo ""
    echo "Quick install (Linux/Mac):"
    echo "  curl https://sdk.cloud.google.com | bash"
    echo "  exec -l \$SHELL"
    exit 1
fi

echo "✅ gcloud CLI found"
echo ""

# Get project ID
PROJECT_ID=$(gcloud config get-value project 2>/dev/null)

if [ -z "$PROJECT_ID" ]; then
    echo "❌ No GCP project set"
    echo "Run: gcloud config set project YOUR_PROJECT_ID"
    exit 1
fi

echo "📦 Project ID: $PROJECT_ID"
echo ""

# Prompt for service name
read -p "Enter service name (default: live-measurements-api): " SERVICE_NAME
SERVICE_NAME=${SERVICE_NAME:-live-measurements-api}

# Prompt for region
echo ""
echo "Select a region:"
echo "  1) us-central1 (Iowa) - Recommended"
echo "  2) us-east1 (South Carolina)"
echo "  3) europe-west1 (Belgium)"
echo "  4) asia-northeast1 (Tokyo)"
echo "  5) asia-southeast1 (Singapore)"
read -p "Enter choice (1-5, default: 1): " REGION_CHOICE
REGION_CHOICE=${REGION_CHOICE:-1}

case $REGION_CHOICE in
    1) REGION="us-central1" ;;
    2) REGION="us-east1" ;;
    3) REGION="europe-west1" ;;
    4) REGION="asia-northeast1" ;;
    5) REGION="asia-southeast1" ;;
    *) REGION="us-central1" ;;
esac

echo ""
echo "Selected region: $REGION"
echo ""

# Prompt for memory
read -p "Memory allocation (default: 4Gi, options: 2Gi, 4Gi, 8Gi): " MEMORY
MEMORY=${MEMORY:-4Gi}

# Prompt for CPU
read -p "CPU count (default: 2, options: 1, 2, 4): " CPU
CPU=${CPU:-2}

# Prompt for authentication
read -p "Allow unauthenticated requests? (y/n, default: y): " ALLOW_UNAUTH
ALLOW_UNAUTH=${ALLOW_UNAUTH:-y}

if [ "$ALLOW_UNAUTH" = "y" ]; then
    AUTH_FLAG="--allow-unauthenticated"
else
    AUTH_FLAG="--no-allow-unauthenticated"
fi

echo ""
echo "📋 Deployment Configuration:"
echo "  Service Name: $SERVICE_NAME"
echo "  Region: $REGION"
echo "  Memory: $MEMORY"
echo "  CPU: $CPU"
echo "  Authentication: $([ "$ALLOW_UNAUTH" = "y" ] && echo "Public" || echo "Required")"
echo ""

read -p "Proceed with deployment? (y/n): " CONFIRM
if [ "$CONFIRM" != "y" ]; then
    echo "❌ Deployment cancelled"
    exit 0
fi

echo ""
echo "🔧 Enabling required APIs..."
gcloud services enable run.googleapis.com --quiet 2>/dev/null || true
gcloud services enable cloudbuild.googleapis.com --quiet 2>/dev/null || true

echo ""
echo "🏗️  Building and deploying to Cloud Run..."
echo "   This may take 5-10 minutes..."
echo ""

# Deploy
gcloud run deploy $SERVICE_NAME \
    --source . \
    --platform managed \
    --region $REGION \
    $AUTH_FLAG \
    --memory $MEMORY \
    --cpu $CPU \
    --timeout 300s \
    --max-instances 10 \
    --quiet

# Get service URL
SERVICE_URL=$(gcloud run services describe $SERVICE_NAME --region $REGION --format 'value(status.url)')

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
echo "  curl -X POST \"$SERVICE_URL/upload_images\" \\"
echo "    -F \"front=@front.jpeg\" \\"
echo "    -F \"left_side=@left_side.jpeg\" \\"
echo "    -F \"height_cm=170\""
echo ""
echo "📊 View logs:"
echo "  gcloud run services logs tail $SERVICE_NAME --region $REGION"
echo ""
echo "🔄 Update service:"
echo "  gcloud run deploy $SERVICE_NAME --source . --region $REGION"
echo ""
echo "🗑️  Delete service:"
echo "  gcloud run services delete $SERVICE_NAME --region $REGION"
echo ""
