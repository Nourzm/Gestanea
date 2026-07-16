
from fastapi import APIRouter
from app.routers.market import products
from app.routers.doctors import doctors
from app.routers.plan import medicines, appointments

# Create main API router
api_router = APIRouter()

# Include route modules
api_router.include_router(products.router, prefix="/products", tags=["products"])
api_router.include_router(doctors.router, prefix="/doctors", tags=["doctors"])
api_router.include_router(medicines.router, prefix="/medicines", tags=["medicines"])
api_router.include_router(appointments.router, prefix="/appointments", tags=["appointments"])

