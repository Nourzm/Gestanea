from pydantic_settings import BaseSettings

class Settings(BaseSettings):
    APP_NAME: str = "Gestanea"
    DEBUG: bool = False
    DATABASE_URL: str
    SECRET_KEY: str
    SUPABASE_URL: str
    SUPABASE_ANON_KEY: str

    class Config:
        env_file = "../.env"
        extra = "allow"

settings = Settings()