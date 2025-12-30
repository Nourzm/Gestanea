from fastapi import APIRouter, Depends, HTTPException, UploadFile, File
from supabase import Client
from app.supabase_client import supabase_client  # Assuming this exports the client
from app.schemas.lab_result import LabResultCreate, LabResult
from typing import List
from uuid import uuid4
from datetime import datetime

router = APIRouter(prefix="/lab_results", tags=["lab_results"])

# Dependency for Supabase client (add to supabase_client.py if needed)
def get_supabase() -> Client:
    return supabase_client

@router.post("/", response_model=LabResult)
def create_lab_result(result: LabResultCreate, db: Client = Depends(get_supabase)):
    # TODO: Get current_user from auth dependency
    if result.user_id != "current_user":  # Placeholder; replace with real auth
        raise HTTPException(status_code=403, detail="Unauthorized")
    
    data = result.dict()
    data["id"] = str(uuid4())
    data["created_at"] = datetime.utcnow().isoformat()
    
    res = db.table("lab_results").insert(data).execute()
    if not res.data:
        raise HTTPException(status_code=400, detail="Failed to create")
    return res.data[0]

@router.get("/", response_model=List[LabResult])
def get_lab_results(user_id: str, db: Client = Depends(get_supabase)):
    # TODO: Auth check
    res = db.table("lab_results").select("*").eq("user_id", user_id).order("lab_date", desc=True).execute()
    return res.data

@router.delete("/{result_id}")
def delete_lab_result(result_id: str, user_id: str, db: Client = Depends(get_supabase)):
    # TODO: Auth check
    res = db.table("lab_results").delete().eq("id", result_id).eq("user_id", user_id).execute()
    if not res.data:
        raise HTTPException(status_code=404, detail="Not found")
    # Delete image if exists (optional)
    return {"message": "Deleted"}

# Upload endpoint for images/PDFs
@router.post("/upload")
async def upload_report(file: UploadFile = File(...), user_id: str = "current_user", db: Client = Depends(get_supabase)):
    # TODO: Auth
    file_path = f"{user_id}/{uuid4()}.{file.filename.split('.')[-1]}"
    contents = await file.read()
    res = db.storage.from_("lab-reports").upload(file_path, contents)
    if res.status_code != 200:
        raise HTTPException(status_code=400, detail="Upload failed")
    url = db.storage.from_("lab-reports").get_public_url(file_path)
    return {"url": url}