# Quick Vercel Deployment Guide

## 📦 Files Added for Vercel

1. ✅ `vercel.json` - Configuration for Vercel deployment
2. ✅ `api/index.py` - Serverless function entry point
3. ✅ `mangum` added to `requirements.txt` - ASGI adapter for serverless

## 🚀 Deploy to Vercel

### Option 1: Deploy via GitHub (Recommended)

1. **Push to GitHub:**
   ```bash
   git add .
   git commit -m "Add Vercel deployment configuration"
   git push origin main
   ```

2. **Go to Vercel:**
   - Visit [vercel.com/new](https://vercel.com/new)
   - Import your GitHub repository
   - Click "Deploy"

### Option 2: Deploy via Vercel CLI

1. **Install Vercel CLI:**
   ```bash
   npm install -g vercel
   ```

2. **Login and Deploy:**
   ```bash
   vercel login
   vercel
   ```

3. **For production:**
   ```bash
   vercel --prod
   ```

## 📝 Important Notes

### ⚠️ Vercel Limitations:
- **Max file size**: 10 MB per upload (Hobby plan)
- **Timeout**: 10 seconds (Hobby), 60 seconds (Pro)
- **Temporary storage**: Files uploaded are stored in `/tmp` and deleted after function execution
- **Deployment size**: 50 MB max

### ⚠️ Your App Considerations:
- Your app uses **PyTorch, MediaPipe, and OpenCV** - these are LARGE dependencies
- **Total size may exceed Vercel's 50 MB limit**
- Consider using **Docker-based deployment** or platforms like:
  - **Railway** (recommended for ML apps)
  - **Render**
  - **Google Cloud Run**
  - **Fly.io**

## 🔧 If Deployment Fails Due to Size

If you get "deployment too large" error, you'll need to:

### Option A: Use Vercel with Docker (Pro plan)
Requires Vercel Pro plan with Docker support

### Option B: Use Alternative Platforms

**Railway (Recommended for your app):**
```bash
# Install Railway CLI
npm install -g @railway/cli

# Login and deploy
railway login
railway init
railway up
```

**Render:**
- Push to GitHub
- Go to [render.com](https://render.com)
- Create new "Web Service"
- Connect your repository
- Build Command: `pip install -r requirements.txt`
- Start Command: `uvicorn app:app --host 0.0.0.0 --port $PORT`

**Google Cloud Run:**
```bash
gcloud run deploy --source .
```

## 📊 Check Your Dependencies Size

Before deploying, check total size:
```bash
pip install -r requirements.txt --target ./package
du -sh ./package
rm -rf ./package
```

## 🌐 After Deployment

Your API will be available at:
- **Base URL**: `https://your-project.vercel.app`
- **Upload endpoint**: `POST https://your-project.vercel.app/upload_images`
- **API Docs**: `https://your-project.vercel.app/docs`

## 🧪 Test Your API

```bash
curl -X POST "https://your-project.vercel.app/upload_images" \
  -F "front=@front_image.jpg" \
  -F "left_side=@side_image.jpg" \
  -F "height_cm=170"
```

## ❓ Need Help?

If Vercel deployment fails due to size limitations, I recommend:
1. **Railway** - Best for ML/AI apps, generous limits
2. **Render** - Free tier with 512 MB RAM
3. **Google Cloud Run** - Pay as you go, handles large apps

Run `vercel` to try deployment and see if it works!
