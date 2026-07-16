from pydantic import BaseModel
from typing import Optional

class DoctorBase(BaseModel):
    name: str
    specialty: Optional[str] = None
    gender: Optional[str] = None
    phone: Optional[str] = None
    email: Optional[str] = None
    address: Optional[str] = None
    latitude: Optional[float] = None
    longitude: Optional[float] = None
    rating: Optional[float] = None
    reviews_count: int = 0
    wilaya: Optional[str] = None

class DoctorCreate(DoctorBase):
    pass

class DoctorResponse(DoctorBase):
    id: str
    distance: Optional[float] = None
    
    class Config:
        from_attributes = True