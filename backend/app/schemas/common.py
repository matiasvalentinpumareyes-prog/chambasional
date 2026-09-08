from typing import Generic, TypeVar

from pydantic import BaseModel, Field

T = TypeVar("T")


class Paginated(BaseModel, Generic[T]):
    """Respuesta paginada genérica usada en todos los listados (customers, products, sales, campaigns)."""

    items: list[T] = Field(..., description="Elementos de la página actual")
    page: int = Field(..., ge=1, description="Página actual (1-indexed)")
    page_size: int = Field(..., ge=1, description="Tamaño de página solicitado")
    total: int = Field(..., ge=0, description="Total de elementos sin paginar")

    model_config = {"from_attributes": True}


class ErrorDetail(BaseModel):
    code: str = Field(..., description="Código machine-readable, ej CUSTOMER_NOT_FOUND")
    message: str = Field(..., description="Mensaje humano (es)")


class ErrorResponse(BaseModel):
    success: bool = Field(default=False, description="Siempre false en errores")
    error: ErrorDetail

    model_config = {"from_attributes": True}


class SuccessResponse(BaseModel):
    """Envoltorio genérico para respuestas exitosas sin paginación cuando se requiere."""

    success: bool = Field(default=True)
    message: str | None = None

    model_config = {"from_attributes": True}
