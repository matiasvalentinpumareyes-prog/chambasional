from fastapi import HTTPException, status


class AppError(HTTPException):
    """
    Excepción base que produce el formato de error consistente pedido en
    la sección 52 del brief:

        { "success": false, "error": { "code": "...", "message": "..." } }

    El manejador global registrado en app/main.py convierte cualquier
    AppError en ese formato. Nunca se exponen stack traces al cliente.
    """

    def __init__(self, code: str, message: str, status_code: int = status.HTTP_400_BAD_REQUEST):
        self.code = code
        self.message = message
        super().__init__(status_code=status_code, detail=message)


class NotFoundError(AppError):
    def __init__(self, code: str, message: str):
        super().__init__(code, message, status.HTTP_404_NOT_FOUND)


class ForbiddenError(AppError):
    def __init__(self, code: str = "FORBIDDEN", message: str = "No tienes permisos para esta acción."):
        super().__init__(code, message, status.HTTP_403_FORBIDDEN)


class UnauthorizedError(AppError):
    def __init__(self, code: str = "UNAUTHORIZED", message: str = "Credenciales inválidas o sesión expirada."):
        super().__init__(code, message, status.HTTP_401_UNAUTHORIZED)


class ConflictError(AppError):
    def __init__(self, code: str, message: str):
        super().__init__(code, message, status.HTTP_409_CONFLICT)
