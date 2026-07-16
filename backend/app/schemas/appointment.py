"""
Appointment Pydantic schemas for request/response validation.

These schemas define the structure of appointment data sent to and received from the API.
"""

from pydantic import BaseModel, Field
from typing import Optional
from datetime import datetime


class AppointmentBase(BaseModel):
    """Base appointment schema with common fields."""
    user_id: str
    baby_id: Optional[str] = None
    title: str = Field(..., min_length=3, max_length=255)
    doctor_name: Optional[str] = None
    appointment_type: Optional[str] = None
    appointment_date: str  # ISO datetime format
    location: Optional[str] = None
    notes: Optional[str] = None
    reminder_time: Optional[str] = None  # ISO datetime format
    is_completed: int = 0


class AppointmentCreate(AppointmentBase):
    """Schema for creating a new appointment."""
    id: Optional[str] = None  # Allow client to provide ID
    created_at: Optional[str] = None  # Allow client to provide timestamp


class AppointmentUpdate(BaseModel):
    """Schema for updating an appointment."""
    title: Optional[str] = Field(None, min_length=3, max_length=255)
    doctor_name: Optional[str] = None
    appointment_type: Optional[str] = None
    appointment_date: Optional[str] = None
    location: Optional[str] = None
    notes: Optional[str] = None
    reminder_time: Optional[str] = None
    is_completed: Optional[int] = None


class AppointmentResponse(AppointmentBase):
    """
    Schema for appointment response.
    Used in GET /appointments endpoints.
    """
    id: str
    created_at: str

    class Config:
        from_attributes = True
