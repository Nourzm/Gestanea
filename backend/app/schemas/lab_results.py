from pydantic import BaseModel
from datetime import datetime
from typing import Optional

class LabResultBase(BaseModel):
    test_name: str
    value: Optional[float] = None
    unit: Optional[str] = None
    min_range: Optional[float] = None
    max_range: Optional[float] = None
    lab_date: datetime
    notes: Optional[str] = None
    report_image_url: Optional[str] = None
    extracted_by_ocr: bool = False

class LabResultCreate(LabResultBase):
    user_id: str

class LabResult(LabResultBase):
    id: str
    user_id: str
    created_at: datetime

    class Config:
        from_attributes = True  # For ORM mode