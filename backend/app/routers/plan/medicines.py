from fastapi import APIRouter, Query, HTTPException
from typing import Optional, List
from app.supabase_client import supabase
from app.schemas.medicine import MedicineCreate, MedicineUpdate, MedicineResponse, MedicineLogCreate, MedicineLogResponse
from datetime import datetime
import json
import uuid

router = APIRouter()


@router.get("/", response_model=List[MedicineResponse])
async def get_medicines(
    user_id: str = Query(..., description="User ID to fetch medicines for"),
    date: Optional[str] = Query(None, description="Filter by date (YYYY-MM-DD)"),
):
    """Get all medicines for a user, optionally filtered by date"""
    try:
        # Start with base query
        query = supabase.table("medicines").select("*").eq("user_id", user_id).eq("is_active", 1).order("created_at", desc=True)
        
        # Apply date filter if provided
        if date:
            query = query.lte("start_date", date).or_(f"end_date.is.null,end_date.gte.{date}")
        
        response = query.execute()
        
        # Parse scheduled_times if it's a JSON string
        medicines = []
        for med in response.data:
            if med.get("scheduled_times") and isinstance(med["scheduled_times"], str):
                try:
                    med["scheduled_times"] = json.loads(med["scheduled_times"])
                except:
                    med["scheduled_times"] = []
            medicines.append(med)
        
        return medicines
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error fetching medicines: {str(e)}")


@router.get("/{medicine_id}", response_model=MedicineResponse)
async def get_medicine(medicine_id: str):
    """Get a specific medicine by ID"""
    try:
        response = supabase.table("medicines").select("*").eq("id", medicine_id).execute()
        
        if not response.data:
            raise HTTPException(status_code=404, detail="Medicine not found")
        
        medicine = response.data[0]
        # Parse scheduled_times if it's a JSON string
        if medicine.get("scheduled_times") and isinstance(medicine["scheduled_times"], str):
            try:
                medicine["scheduled_times"] = json.loads(medicine["scheduled_times"])
            except:
                medicine["scheduled_times"] = []
        
        return medicine
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error fetching medicine: {str(e)}")


@router.post("/", response_model=MedicineResponse, status_code=201)
async def create_medicine(medicine: MedicineCreate):
    """Create a new medicine"""
    try:
        # Convert scheduled_times list to JSON string if needed
        medicine_data = medicine.model_dump()
        if medicine_data.get("scheduled_times"):
            medicine_data["scheduled_times"] = json.dumps(medicine_data["scheduled_times"])
        
        # Use client-provided ID if available, otherwise generate UUID
        if not medicine_data.get("id"):
            medicine_data["id"] = str(uuid.uuid4())
        
        # Use client-provided created_at if available, otherwise use current time
        if not medicine_data.get("created_at"):
            medicine_data["created_at"] = datetime.utcnow().isoformat()
        
        response = supabase.table("medicines").insert(medicine_data).execute()
        
        if not response.data:
            raise HTTPException(status_code=400, detail="Failed to create medicine")
        
        result = response.data[0]
        # Parse scheduled_times back to list
        if result.get("scheduled_times") and isinstance(result["scheduled_times"], str):
            try:
                result["scheduled_times"] = json.loads(result["scheduled_times"])
            except:
                result["scheduled_times"] = []
        
        return result
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error creating medicine: {str(e)}")


@router.put("/{medicine_id}", response_model=MedicineResponse)
async def update_medicine(medicine_id: str, medicine: MedicineUpdate):
    """Update an existing medicine"""
    try:
        # Only include fields that were provided
        update_data = medicine.model_dump(exclude_unset=True)
        
        if not update_data:
            raise HTTPException(status_code=400, detail="No fields to update")
        
        # Convert scheduled_times list to JSON string if provided
        if "scheduled_times" in update_data and update_data["scheduled_times"]:
            update_data["scheduled_times"] = json.dumps(update_data["scheduled_times"])
        
        response = supabase.table("medicines").update(update_data).eq("id", medicine_id).execute()
        
        if not response.data:
            raise HTTPException(status_code=404, detail="Medicine not found")
        
        result = response.data[0]
        # Parse scheduled_times back to list
        if result.get("scheduled_times") and isinstance(result["scheduled_times"], str):
            try:
                result["scheduled_times"] = json.loads(result["scheduled_times"])
            except:
                result["scheduled_times"] = []
        
        return result
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error updating medicine: {str(e)}")


@router.delete("/{medicine_id}")
async def delete_medicine(medicine_id: str):
    """Soft delete a medicine by setting is_active to False"""
    try:
        response = supabase.table("medicines").update({"is_active": 0}).eq("id", medicine_id).execute()
        
        if not response.data:
            raise HTTPException(status_code=404, detail="Medicine not found")
        
        return {"message": "Medicine deleted successfully", "state": True}
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error deleting medicine: {str(e)}")


# Medicine Logs endpoints

@router.get("/logs/", response_model=List[MedicineLogResponse])
async def get_medicine_logs(
    user_id: str = Query(..., description="User ID to fetch logs for"),
    date: str = Query(..., description="Date to fetch logs for (YYYY-MM-DD)"),
):
    """Get all medicine logs for a user on a specific date"""
    try:
        response = supabase.table("medicine_logged").select("*").eq("user_id", user_id).eq("logged_date", date).order("logged_at", desc=True).execute()
        
        return response.data
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error fetching medicine logs: {str(e)}")


@router.post("/logs/", response_model=MedicineLogResponse, status_code=201)
async def create_medicine_log(log: MedicineLogCreate):
    """Log a medicine intake"""
    try:
        log_data = log.model_dump()
        
        response = supabase.table("medicine_logged").insert(log_data).execute()
        
        if not response.data:
            raise HTTPException(status_code=400, detail="Failed to create medicine log")
        
        return response.data[0]
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error creating medicine log: {str(e)}")
