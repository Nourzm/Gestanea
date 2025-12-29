from fastapi import APIRouter, HTTPException, status, Query
from typing import List, Optional
from app.schemas.product import (
    ProductResponse,
    ProductCategoryResponse,
    ProductVariantResponse,
    ProductSpecResponse,
    ProductReviewCreate,
    ProductReviewUpdate,
    ProductReviewResponse
)
from app.supabase_client import supabase

router = APIRouter()

# ==================== PRODUCTS ====================

@router.get("/", response_model=List[ProductResponse])
def get_products(
    skip: int = Query(0, ge=0, description="Number of records to skip"),
    limit: int = Query(100, ge=1, le=1000, description="Maximum number of records to return"),
    category_id: Optional[str] = Query(None, description="Filter by category ID"),
    is_available: Optional[bool] = Query(None, description="Filter by availability"),
    search: Optional[str] = Query(None, description="Search in product name")
):
    """
    Get all products with optional filtering and pagination.
    
    Args:
        skip: Number of records to skip (for pagination)
        limit: Maximum number of records to return
        category_id: Filter by category ID
        is_available: Filter by availability
        search: Search in product name
    
    Returns:
        List of products
    """
    try:
        query = supabase.table("products").select("*")
        
        # Apply filters
        if category_id:
            query = query.eq("category_id", category_id)
        
        if is_available is not None:
            availability_int = 1 if is_available else 0
            query = query.eq("is_available", availability_int)
        
        if search:
            query = query.ilike("product_name", f"%{search}%")
        
        # Apply pagination
        query = query.range(skip, skip + limit - 1)
        
        # Order by created_at descending
        query = query.order("created_at", desc=True)
        
        response = query.execute()
        return response.data
    
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Error fetching products: {str(e)}"
        )


@router.get("/{product_id}", response_model=ProductResponse)
def get_product(product_id: str):
    """
    Get a single product by ID.
    
    Args:
        product_id: Unique product identifier
    
    Returns:
        Product object
    
    Raises:
        HTTPException: If product not found
    """
    try:
        response = supabase.table("products").select("*").eq("id", product_id).execute()
        
        if not response.data:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=f"Product with id {product_id} not found"
            )
        
        return response.data[0]
    
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Error fetching product: {str(e)}"
        )


# ==================== PRODUCT CATEGORIES ====================

@router.get("/categories/", response_model=List[ProductCategoryResponse])
def get_categories():
    """
    Get all product categories.
    
    Returns:
        List of all categories ordered by display_order
    """
    try:
        response = supabase.table("product_categories").select("*").order("display_order", desc=False).execute()
        return response.data
    
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Error fetching categories: {str(e)}"
        )


@router.get("/categories/{category_id}", response_model=ProductCategoryResponse)
def get_category(category_id: str):
    """
    Get a single category by ID.
    
    Args:
        category_id: Unique category identifier
    
    Returns:
        Category object
    
    Raises:
        HTTPException: If category not found
    """
    try:
        response = supabase.table("product_categories").select("*").eq("id", category_id).execute()
        
        if not response.data:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=f"Category with id {category_id} not found"
            )
        
        return response.data[0]
    
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Error fetching category: {str(e)}"
        )


# ==================== PRODUCT VARIANTS ====================

@router.get("/{product_id}/variants", response_model=List[ProductVariantResponse])
def get_product_variants(product_id: str):
    """Get all variants for a specific product."""
    try:
        response = supabase.table("product_variants").select("*").eq("product_id", product_id).order("created_at", desc=False).execute()
        return response.data
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Error fetching product variants: {str(e)}"
        )


# ==================== PRODUCT SPECS ====================

@router.get("/{product_id}/specs", response_model=List[ProductSpecResponse])
def get_product_specs(product_id: str):
    """Get all specs for a specific product."""
    try:
        response = supabase.table("product_specs").select("*").eq("product_id", product_id).order("created_at", desc=False).execute()
        return response.data
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Error fetching product specs: {str(e)}"
        )


# ==================== PRODUCT REVIEWS ====================

@router.get("/{product_id}/reviews", response_model=List[ProductReviewResponse])
def get_product_reviews(
    product_id: str,
    skip: int = Query(0, ge=0, description="Number of records to skip"),
    limit: int = Query(100, ge=1, le=1000, description="Maximum number of records to return")
):
    """
    Get all reviews for a specific product with pagination.
    
    Args:
        product_id: Unique product identifier
        skip: Number of records to skip (for pagination)
        limit: Maximum number of records to return
    
    Returns:
        List of reviews for the product
    """
    try:
        response = supabase.table("product_reviews").select("*").eq("product_id", product_id).range(skip, skip + limit - 1).order("created_at", desc=True).execute()
        return response.data
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Error fetching product reviews: {str(e)}"
        )


@router.post("/{product_id}/reviews", response_model=ProductReviewResponse, status_code=status.HTTP_201_CREATED)
def create_product_review(product_id: str, review_data: ProductReviewCreate):
    """Create a new review for a product."""
    try:
        review_dict = review_data.model_dump()
        review_dict["product_id"] = product_id  # Ensure product_id matches
        response = supabase.table("product_reviews").insert(review_dict).execute()
        
        if not response.data:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Failed to create product review"
            )
        
        return response.data[0]
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Error creating product review: {str(e)}"
        )


@router.put("/reviews/{review_id}", response_model=ProductReviewResponse)
def update_product_review(review_id: str, review_data: ProductReviewUpdate):
    """Update a product review."""
    try:
        existing = supabase.table("product_reviews").select("id").eq("id", review_id).execute()
        
        if not existing.data:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=f"Review with id {review_id} not found"
            )
        
        update_dict = review_data.model_dump(exclude_unset=True)
        response = supabase.table("product_reviews").update(update_dict).eq("id", review_id).execute()
        
        if not response.data:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Failed to update product review"
            )
        
        return response.data[0]
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Error updating product review: {str(e)}"
        )


@router.delete("/reviews/{review_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_product_review(review_id: str):
    """Delete a product review."""
    try:
        # First check if review exists
        existing = supabase.table("product_reviews").select("id").eq("id", review_id).execute()
        
        if not existing.data:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=f"Review with id {review_id} not found"
            )
        
        # Perform the delete operation
        delete_response = supabase.table("product_reviews").delete().eq("id", review_id).execute()
        
        # Verify deletion actually happened
        if not delete_response.data:
            # Check if it was actually deleted
            verify = supabase.table("product_reviews").select("id").eq("id", review_id).execute()
            if verify.data:
                raise HTTPException(
                    status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                    detail="Failed to delete review - it still exists in database"
                )
        
        return None
        
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Error deleting product review: {str(e)}"
        )