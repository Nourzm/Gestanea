from fastapi import APIRouter, Query, HTTPException
from typing import Optional, List
from app.supabase_client import supabase
from app.schemas.doctor import DoctorResponse
from math import radians, cos, sin, asin, sqrt

router = APIRouter()

def calculate_distance(lat1: float, lon1: float, lat2: float, lon2: float) -> float:
    """Calculate distance between two points using Haversine formula (in km)"""
    lon1, lat1, lon2, lat2 = map(radians, [lon1, lat1, lon2, lat2])
    dlon = lon2 - lon1
    dlat = lat2 - lat1
    a = sin(dlat/2)**2 + cos(lat1) * cos(lat2) * sin(dlon/2)**2
    c = 2 * asin(sqrt(a))
    km = 6371 * c
    return round(km, 1)

@router.get("/", response_model=List[DoctorResponse])
async def get_doctors(
    search: Optional[str] = Query(None, description="Search by name or specialty"),
    wilaya: Optional[str] = Query(None, description="Filter by wilaya"),
    specialty: Optional[str] = Query(None, description="Filter by specialty"),
    gender: Optional[str] = Query(None, description="Filter by gender"),
    min_rating: Optional[float] = Query(None, ge=0, le=5),
    min_reviews: Optional[int] = Query(None, ge=0),
    max_distance: Optional[float] = Query(None, ge=0),
    user_lat: Optional[float] = Query(None, description="User latitude for distance calculation"),
    user_lon: Optional[float] = Query(None, description="User longitude for distance calculation"),
    sort_by: Optional[str] = Query("distance", description="Sort by: distance, rating, reviews")
):
    """Get all doctors with optional filters and sorting"""
    try:
        # Start with base query
        query = supabase.table("doctors").select("*")
        
        # Apply wilaya filter
        if wilaya and wilaya != "Use current location":
            query = query.eq("wilaya", wilaya)
        
        # Apply specialty filter
        if specialty:
            query = query.eq("specialty", specialty)
        
        # Apply gender filter
        if gender:
            query = query.eq("gender", gender)
        
        # Apply rating filter
        if min_rating is not None:
            query = query.gte("rating", min_rating)
        
        # Apply reviews filter
        if min_reviews is not None:
            query = query.gte("reviews_count", min_reviews)
        
        # Execute query
        response = query.execute()
        doctors = response.data
        
        # Calculate distances if user location provided
        if user_lat is not None and user_lon is not None:
            for doctor in doctors:
                if doctor.get("latitude") and doctor.get("longitude"):
                    doctor["distance"] = calculate_distance(
                        user_lat, user_lon,
                        doctor["latitude"], doctor["longitude"]
                    )
                else:
                    doctor["distance"] = None
        
        # Apply distance filter after calculation
        if max_distance is not None:
            doctors = [d for d in doctors if d.get("distance") is not None and d["distance"] <= max_distance]
        
        # Apply search filter
        if search:
            search_lower = search.lower().strip()
            doctors = [
                d for d in doctors
                if search_lower in d["name"].lower() or 
                   (d.get("specialty") and search_lower in d["specialty"].lower())
            ]
        
        # Apply sorting
        if sort_by == "rating":
            doctors.sort(key=lambda x: x.get("rating") or 0, reverse=True)
        elif sort_by == "reviews":
            doctors.sort(key=lambda x: x.get("reviews_count") or 0, reverse=True)
        elif sort_by == "distance":
            doctors.sort(key=lambda x: x.get("distance") or float('inf'))
        else:
            # Default sort by distance
            doctors.sort(key=lambda x: x.get("distance") or float('inf'))
        
        return doctors
        
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@router.get("/{doctor_id}", response_model=DoctorResponse)
async def get_doctor(
    doctor_id: str,
    user_lat: Optional[float] = Query(None),
    user_lon: Optional[float] = Query(None)
):
    """Get a single doctor by ID"""
    try:
        response = supabase.table("doctors").select("*").eq("id", doctor_id).execute()
        
        if not response.data:
            raise HTTPException(status_code=404, detail="Doctor not found")
        
        doctor = response.data[0]
        
        # Calculate distance if user location provided
        if user_lat is not None and user_lon is not None:
            if doctor.get("latitude") and doctor.get("longitude"):
                doctor["distance"] = calculate_distance(
                    user_lat, user_lon,
                    doctor["latitude"], doctor["longitude"]
                )
        
        return doctor
        
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@router.get("/specialties/list", response_model=List[str])
async def get_specialties():
    """Get list of unique specialties"""
    try:
        response = supabase.table("doctors").select("specialty").execute()
        specialties = list(set([d["specialty"] for d in response.data if d.get("specialty")]))
        return sorted(specialties)
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@router.get("/wilayas/list", response_model=List[str])
async def get_wilayas():
    """Get list of unique wilayas"""
    try:
        response = supabase.table("doctors").select("wilaya").execute()
        wilayas = list(set([d["wilaya"] for d in response.data if d.get("wilaya")]))
        return sorted(wilayas)
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))