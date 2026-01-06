from app import app
from mangum import Mangum

# Vercel serverless handler
handler = Mangum(app)
