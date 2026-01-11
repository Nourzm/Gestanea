"""
Medicine Pydantic schemas for request/response validation.

These schemas define the structure of medicine data sent to and received from the API.
"""

from pydantic import BaseModel, Field
from typing import Optional, List
from datetime import datetime


class MedicineBase(BaseModel):
    """Base medicine schema with common fields."""
    user_id: Optional[str] = None
    baby_id: Optional[str] = None
    medicine_name: str = Field(..., min_length=1, max_length=255)
    dosage: str
    type: Optional[str] = None
    frequency_type: str
    frequency_value: Optional[int] = None
    scheduled_times: Optional[List[str]] = None
    start_date: str  # ISO date format YYYY-MM-DD
    end_date: Optional[str] = None  # ISO date format YYYY-MM-DD
    medicine_image_url: Optional[str] = None
    is_active: int = 1


class MedicineCreate(MedicineBase):
    """Schema for creating a new medicine."""
    id: Optional[str] = None  # Allow client to provide ID
    created_at: Optional[str] = None  # Allow client to provide timestamp


class MedicineUpdate(BaseModel):
    """Schema for updating a medicine."""
    medicine_name: Optional[str] = Field(None, min_length=1, max_length=255)
    dosage: Optional[str] = None
    type: Optional[str] = None
    frequency_type: Optional[str] = None
    frequency_value: Optional[int] = None
    scheduled_times: Optional[List[str]] = None
    start_date: Optional[str] = None
    end_date: Optional[str] = None
    medicine_image_url: Optional[str] = None
    is_active: Optional[int] = None


class MedicineResponse(MedicineBase):
    """
    Schema for medicine response.
    Used in GET /medicines endpoints.
    """
    id: str
    created_at: str

    class Config:
        from_attributes = True


class MedicineLogBase(BaseModel):
    """Base medicine log schema."""
    medicine_id: str
    user_id: str
    logged_date: str  # ISO date format YYYY-MM-DD
    logged_at: str  # ISO datetime format
    status: str  # Status: taken, missed, or skipped
    notes: Optional[str] = None


class MedicineLogCreate(MedicineLogBase):
    """Schema for creating a medicine log."""
    id: str  # Client-generated UUID


class MedicineLogResponse(MedicineLogBase):
    """Schema for medicine log response."""
    id: str

    class Config:
        from_attributes = True
