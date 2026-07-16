"""
Product Pydantic schemas for request/response validation.

These schemas define the structure of product data sent to and received from the API.
"""

from pydantic import BaseModel, Field
from typing import Optional, List


class ProductBase(BaseModel):
    """Base product schema with common fields."""
    product_name: str = Field(..., min_length=1, max_length=255)
    description: Optional[str] = None
    category_id: str
    target_audience: Optional[str] = None
    price: float = Field(..., gt=0)
    original_price: Optional[float] = None
    discount_percentage: Optional[int] = Field(None, ge=0, le=100)
    currency: str = "USD"
    rating: float = Field(default=0.0, ge=0.0, le=5.0)
    reviews_count: int = Field(default=0, ge=0)
    image_urls: str  # JSON string or comma-separated URLs
    vendor_name: Optional[str] = None
    is_available: bool = True
    translations: Optional[dict] = None  # JSON field for multi-language support




class ProductResponse(ProductBase):
    """
    Schema for product response.
    Used in GET /products endpoints.
    """
    id: str
    created_at: Optional[str] = None
    
    class Config:
        from_attributes = True


class ProductCategoryBase(BaseModel):
    """Base product category schema."""
    name: str = Field(..., min_length=1, max_length=255)
    image_url: Optional[str] = None
    display_order: Optional[int] = 0
    translations: Optional[dict] = None  # JSON field for multi-language support




class ProductCategoryResponse(ProductCategoryBase):
    """Schema for product category response."""
    id: str
    created_at: Optional[str] = None
    
    class Config:
        from_attributes = True


# ==================== PRODUCT VARIANTS ====================

class ProductVariantBase(BaseModel):
    """Base product variant schema."""
    product_id: str
    type: str = Field(..., min_length=1, max_length=50)  # e.g., "size", "color"
    value: str = Field(..., min_length=1, max_length=100)  # e.g., "Large", "Red"
    color_hex: Optional[str] = None
    stock: int = Field(default=0, ge=0)








class ProductVariantResponse(ProductVariantBase):
    """Schema for product variant response."""
    id: str
    created_at: Optional[str] = None
    
    class Config:
        from_attributes = True


# ==================== PRODUCT SPECS ====================

class ProductSpecBase(BaseModel):
    """Base product spec schema."""
    product_id: str
    name: str = Field(..., min_length=1, max_length=255)
    value: str = Field(..., min_length=1)





class ProductSpecResponse(ProductSpecBase):
    """Schema for product spec response."""
    id: str
    created_at: Optional[str] = None
    
    class Config:
        from_attributes = True


# ==================== PRODUCT REVIEWS ====================

class ProductReviewBase(BaseModel):
    """Base product review schema."""
    product_id: str
    user_id: str
    reviewer_name: str = Field(..., min_length=1, max_length=255)
    rating: int = Field(..., ge=1, le=5)
    review_text: Optional[str] = None


class ProductReviewCreate(ProductReviewBase):
    """Schema for creating a new product review."""
    id: str = Field(..., description="Unique review identifier")


class ProductReviewUpdate(BaseModel):
    """Schema for updating a product review."""
    reviewer_name: Optional[str] = Field(None, min_length=1, max_length=255)
    rating: Optional[int] = Field(None, ge=1, le=5)
    review_text: Optional[str] = None


class ProductReviewResponse(ProductReviewBase):
    """Schema for product review response."""
    id: str
    created_at: Optional[str] = None
    
    class Config:
        from_attributes = True
