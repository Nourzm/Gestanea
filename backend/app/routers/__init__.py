
from fastapi import APIRouter
from app.routers.market import products
from app.routers.doctors import doctors

# Create main API router
api_router = APIRouter()

# Include route modules
api_router.include_router(products.router, prefix="/products", tags=["products"])
api_router.include_router(doctors.router, prefix="/doctors", tags=["doctors"])

