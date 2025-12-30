from pydantic_settings import BaseSettings

class Settings(BaseSettings):
    APP_NAME: str = "Gestanea"
    DEBUG: bool = False
    DATABASE_URL: str
    SECRET_KEY: str
    SUPABASE_URL: str
    SUPABASE_ANON_KEY: str
    
    # API Base URL 
   
    API_BASE_URL: str = "http://10.0.2.2:8000/api/v1"

    class Config:
        env_file = "../.env"
        extra = "allow"

settings = Settings()