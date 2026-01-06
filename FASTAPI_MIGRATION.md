# Flask to FastAPI Migration Guide

## Changes Made

### 1. **Imports Updated**
- Replaced `Flask, request, jsonify` with `FastAPI, File, UploadFile, Form, HTTPException`
- Added `JSONResponse` for JSON responses
- Added `Optional` from typing for optional parameters
- Added `io` module (though not needed in final implementation)

### 2. **App Initialization**
- Changed from `app = Flask(__name__)` to `app = FastAPI()`

### 3. **Endpoint Conversion**
The `/upload_images` endpoint has been converted from Flask to FastAPI:

**Flask (old):**
```python
@app.route("/upload_images", methods=["POST"])
def upload_images():
    front_image_file = request.files["front"]
    user_height_cm = request.form.get('height_cm')
```

**FastAPI (new):**
```python
@app.post("/upload_images")
async def upload_images(
    front: UploadFile = File(...),
    left_side: Optional[UploadFile] = File(None),
    height_cm: Optional[float] = Form(None)
):
```

### 4. **File Handling**
- FastAPI uses `UploadFile` objects
- File reading is async: `await front.read()`
- No need to manually check if files exist - FastAPI handles validation

### 5. **Error Handling**
- Replaced `return jsonify({...}), 400` with `raise HTTPException(status_code=400, detail={...})`

### 6. **Response**
- Return `JSONResponse(content={...})` instead of `jsonify({...})`

### 7. **Server Execution**
- Changed from `app.run()` to `uvicorn.run(app, ...)`

## Installation

Install the new dependencies:
```bash
pip install -r requirements.txt
```

## Running the Application

### Method 1: Direct Python execution
```bash
python app.py
```

### Method 2: Using Uvicorn command (recommended for production)
```bash
uvicorn app:app --host 0.0.0.0 --port 8001 --reload
```

The `--reload` flag enables auto-reload during development.

## Testing the API

### Using cURL
```bash
curl -X POST "http://localhost:8001/upload_images" \
  -F "front=@/path/to/front_image.jpg" \
  -F "left_side=@/path/to/left_side_image.jpg" \
  -F "height_cm=170"
```

### Using Python requests
```python
import requests

files = {
    'front': open('front_image.jpg', 'rb'),
    'left_side': open('left_side_image.jpg', 'rb')
}
data = {'height_cm': 170}

response = requests.post('http://localhost:8001/upload_images', files=files, data=data)
print(response.json())
```

## API Documentation

FastAPI automatically generates interactive API documentation:
- **Swagger UI**: http://localhost:8001/docs
- **ReDoc**: http://localhost:8001/redoc

## Key Benefits of FastAPI

1. **Automatic API Documentation** - Interactive docs at `/docs`
2. **Type Validation** - Automatic request/response validation
3. **Better Performance** - Async support and faster than Flask
4. **Modern Python** - Uses Python type hints
5. **Better Error Messages** - Clear validation errors

## Differences to Note

1. **Async/Await**: The endpoint is now `async`, which allows for better performance
2. **Type Hints**: Parameters have explicit types for validation
3. **Automatic Validation**: FastAPI validates file types and form data automatically
4. **Optional Parameters**: Use `Optional[Type] = None` or `Type | None = None`
