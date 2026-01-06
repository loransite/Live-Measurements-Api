# Use official Python runtime as base image
FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Install system dependencies for OpenCV, MediaPipe, and other libraries
RUN apt-get update && apt-get install -y \
    libgl1-mesa-glx \
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxrender-dev \
    libgomp1 \
    libgstreamer1.0-0 \
    libgstreamer-plugins-base1.0-0 \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements first for better caching
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application
COPY . .

# Expose port 8080 (Cloud Run default)
EXPOSE 8080

# Run the application with uvicorn
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8080"]
