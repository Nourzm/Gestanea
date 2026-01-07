from fastapi import APIRouter, Query, HTTPException
from typing import Optional, List
from app.supabase_client import supabase
from app.schemas.appointment import AppointmentCreate, AppointmentUpdate, AppointmentResponse
from datetime import datetime

router = APIRouter()


@router.get("/", response_model=List[AppointmentResponse])
async def get_appointments(
    user_id: str = Query(..., description="User ID to fetch appointments for"),
    date: Optional[str] = Query(None, description="Filter by date (YYYY-MM-DD)"),
    upcoming: bool = Query(False, description="Get only upcoming appointments"),
):
    """Get all appointments for a user, optionally filtered by date or upcoming status"""
    try:
        # Start with base query
        query = supabase.table("appointments").select("*").eq("user_id", user_id)
        
        # Apply date filter if provided
        if date:
            # Filter by appointments on the specified date
            query = query.gte("appointment_date", f"{date}T00:00:00").lte("appointment_date", f"{date}T23:59:59")
        
        # Apply upcoming filter
        if upcoming:
            now = datetime.utcnow().isoformat()
            query = query.gte("appointment_date", now).eq("is_completed", 0).limit(10)
        
        response = query.order("appointment_date", desc=False).execute()
        
        return response.data
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error fetching appointments: {str(e)}")


@router.get("/{appointment_id}", response_model=AppointmentResponse)
async def get_appointment(appointment_id: str):
    """Get a specific appointment by ID"""
    try:
        response = supabase.table("appointments").select("*").eq("id", appointment_id).execute()
        
        if not response.data:
            raise HTTPException(status_code=404, detail="Appointment not found")
        
        return response.data[0]
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error fetching appointment: {str(e)}")


@router.post("/", response_model=AppointmentResponse, status_code=201)
async def create_appointment(appointment: AppointmentCreate):
    """Create a new appointment"""
    try:
        # Validate title length
        if len(appointment.title.strip()) <= 2:
            raise HTTPException(status_code=400, detail="Appointment title length should be > 2")
        
        appointment_data = appointment.model_dump()
        
        # Add created_at timestamp
        appointment_data["created_at"] = datetime.utcnow().isoformat()
        
        response = supabase.table("appointments").insert(appointment_data).execute()
        
        if not response.data:
            raise HTTPException(status_code=400, detail="Failed to create appointment")
        
        return response.data[0]
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error creating appointment: {str(e)}")


@router.put("/{appointment_id}", response_model=AppointmentResponse)
async def update_appointment(appointment_id: str, appointment: AppointmentUpdate):
    """Update an existing appointment"""
    try:
        # Only include fields that were provided
        update_data = appointment.model_dump(exclude_unset=True)
        
        if not update_data:
            raise HTTPException(status_code=400, detail="No fields to update")
        
        # Validate title length if provided
        if "title" in update_data and len(update_data["title"].strip()) <= 2:
            raise HTTPException(status_code=400, detail="Appointment title length should be > 2")
        
        response = supabase.table("appointments").update(update_data).eq("id", appointment_id).execute()
        
        if not response.data:
            raise HTTPException(status_code=404, detail="Appointment not found")
        
        return response.data[0]
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error updating appointment: {str(e)}")


@router.patch("/{appointment_id}/status", response_model=AppointmentResponse)
async def update_appointment_status(
    appointment_id: str,
    is_completed: bool = Query(..., description="Mark appointment as completed or not"),
):
    """Update the completion status of an appointment"""
    try:
        response = supabase.table("appointments").update({"is_completed": is_completed}).eq("id", appointment_id).execute()
        
        if not response.data:
            raise HTTPException(status_code=404, detail="Appointment not found")
        
        return response.data[0]
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error updating appointment status: {str(e)}")


@router.delete("/{appointment_id}")
async def delete_appointment(appointment_id: str):
    """Delete an appointment"""
    try:
        response = supabase.table("appointments").delete().eq("id", appointment_id).execute()
        
        if not response.data:
            raise HTTPException(status_code=404, detail="Appointment not found")
        
        return {"message": "Appointment deleted successfully", "state": True}
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error deleting appointment: {str(e)}")
