

from fastapi import FastAPI

from app.core.config import settings
from app.core.database import init_db
from app.routers import api_router

# Create FastAPI application instance
app = FastAPI(
    title=settings.APP_NAME,
    description="Backend API for Gestanea mobile application",
    docs_url="/docs",  # Swagger UI at /docs
    redoc_url="/redoc",  # ReDoc at /redoc
)


# Include root route directly (for convenience)
@app.get("/")
async def root():
    """Root endpoint that redirects to API info."""
    return {
        "message": "Welcome to Gestanea API",
        "docs": "/docs",
        "api_base": "/api/v1"
    }

# Include API routes
app.include_router(api_router, prefix="/api/v1")


@app.on_event("startup")
async def startup_event():
    """
    Startup event handler.
    This runs when the FastAPI application starts.
    """
    # Initialize local database 
  
    init_db()
    print(f"Local database initialized: {settings.DATABASE_URL}")
    
    # Verify Supabase connection 
    if settings.SUPABASE_URL and settings.SUPABASE_ANON_KEY:
        print(f"Supabase configured: {settings.SUPABASE_URL[:30]}...")
    
    print(f"{settings.APP_NAME} started successfully")
    print(f"API Documentation available at: http://localhost:8000/docs")


@app.on_event("shutdown")
async def shutdown_event():

    print(f"{settings.APP_NAME} shutting down...")


if __name__ == "__main__":
    import uvicorn
    
    # Run the server
    uvicorn.run(
        "main:app",
        host="0.0.0.0",
        port=8000,
        reload=True  # Auto-reload on code changes (development only)
    )

