#!/bin/bash

# Test script for deployed API

if [ -z "$1" ]; then
    echo "Usage: ./test-api.sh <SERVICE_URL>"
    echo ""
    echo "Example:"
    echo "  ./test-api.sh https://live-measurements-api-xxxxx-uc.a.run.app"
    echo ""
    echo "Or get your service URL with:"
    echo "  gcloud run services describe live-measurements-api --region us-central1 --format 'value(status.url)'"
    exit 1
fi

SERVICE_URL=$1

echo "🧪 Testing Live Measurements API"
echo "================================"
echo "Service URL: $SERVICE_URL"
echo ""

# Test 1: Check if service is up
echo "Test 1: Checking API health..."
STATUS=$(curl -s -o /dev/null -w "%{http_code}" $SERVICE_URL/docs)
if [ $STATUS -eq 200 ]; then
    echo "✅ API is up and running"
else
    echo "❌ API returned status: $STATUS"
fi

echo ""

# Test 2: Check if we have test images
if [ ! -f "front.jpeg" ]; then
    echo "⚠️  Warning: front.jpeg not found. Upload test will be skipped."
    echo "   Place a test image named 'front.jpeg' in this directory to test uploads."
    echo ""
else
    echo "Test 2: Testing image upload endpoint..."
    
    if [ -f "left_side.jpeg" ]; then
        RESPONSE=$(curl -s -X POST "$SERVICE_URL/upload_images" \
            -F "front=@front.jpeg" \
            -F "left_side=@left_side.jpeg" \
            -F "height_cm=170")
    else
        RESPONSE=$(curl -s -X POST "$SERVICE_URL/upload_images" \
            -F "front=@front.jpeg" \
            -F "height_cm=170")
    fi
    
    if echo "$RESPONSE" | grep -q "measurements"; then
        echo "✅ Upload endpoint working!"
        echo ""
        echo "Response:"
        echo "$RESPONSE" | python3 -m json.tool 2>/dev/null || echo "$RESPONSE"
    else
        echo "❌ Upload failed"
        echo "Response: $RESPONSE"
    fi
fi

echo ""
echo "📚 API Documentation: $SERVICE_URL/docs"
echo "📖 Alternative Docs: $SERVICE_URL/redoc"
echo ""
