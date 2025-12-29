
from fastapi import APIRouter
from app.routers.market import products

# Create main API router
api_router = APIRouter()

# Include route modules
api_router.include_router(products.router, prefix="/products", tags=["products"])

