"""
Database connection and session management.

This module handles SQLAlchemy database connection, session creation,
and provides a dependency for FastAPI routes to access the local database.

This local database connection is available for other features that need local database access.
"""

from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker, Session
from typing import Generator, Optional

from app.core.config import settings

# Initialize as None - will be created only if needed
engine: Optional[object] = None
SessionLocal: Optional[sessionmaker] = None
Base = declarative_base()


def get_engine():
    """
    Get or create SQLAlchemy engine.
    Only creates connection when actually needed.
    """
    global engine
    if engine is None:
      
        if settings.DATABASE_URL.startswith("sqlite"):
            engine = create_engine(
                settings.DATABASE_URL,
                connect_args={"check_same_thread": False},
                echo=settings.DEBUG  
            )
        else:
            engine = create_engine(
                settings.DATABASE_URL,
                echo=settings.DEBUG
            )
    return engine


def get_db() -> Generator[Session, None, None]:
    """
    Dependency function for FastAPI routes to get database session.
    
    Usage in routes:
        @app.get("/items")
        def get_items(db: Session = Depends(get_db)):
            ...
    
    Note: This will only connect to local database when actually used.
    """
    global SessionLocal
    if SessionLocal is None:
        SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=get_engine())
    
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


def init_db():
    """
    Initialize database tables.
    Note: This will NOT modify existing tables, only create missing ones.
    """
   

    Base.metadata.create_all(bind=get_engine())

